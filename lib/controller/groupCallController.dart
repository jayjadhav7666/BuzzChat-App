import 'dart:developer';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/groupCallModel.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/groupcallPage/audioCallPage.dart';
import 'package:buzzchat/pages/groupcallPage/videoCallPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class GroupCallController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid().v4();
  Profilecontroller profilecontroller = Get.put(Profilecontroller());
  String groupId = '';

  @override
  void onInit() {
    super.onInit();
    getGroupCallNotification().listen((List<GroupCallModel> callList) {
      if (callList.isNotEmpty) {
        var callData = callList[0];
        if (callData.type == "audio") {
          groupAudioCallNotification(callData);
        } else if (callData.type == "video") {
          groupVideoCallNotification(callData);
        }
      }
    });
  }

  Future<void> initiateGroupCall(
    List<UserModel> receivers,
    UserModel caller,
    String type,
    GroupModel groupModel,
  ) async {
    String id = uuid;
    DateTime timestamp = DateTime.now();
    String nowTime = DateFormat('hh:mm a').format(timestamp);
    groupId = groupId;
    List<Map<String, String>> participants =
        receivers
            .map(
              (user) => {
                "id": user.id!,
                "name": user.name!,
                "email": user.email!,
                "profileImage": user.profileImage ?? "",
              },
            )
            .toList();

    List<String> participantUids = receivers.map((user) => user.id!).toList();

    var newCall = GroupCallModel(
      id: groupId,
      groupName: groupModel.name,
      groupPic: groupModel.profileUrl,
      callerName: caller.name,
      callerPic: caller.profileImage,
      callerUid: caller.id,
      callerEmail: caller.email,
      participants: participants,
      participantUids: participantUids,
      status: 'dialing',
      time: nowTime,
      type: type,
      timestamp: timestamp.toString(),
    );

    try {
      for (var receiver in receivers) {
        await firebaseFirestore
            .collection('notification')
            .doc(receiver.id)
            .collection('groupCall')
            .doc(id)
            .set(newCall.toJson());
      }

      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('groupCalls')
          .add(newCall.toJson());

      for (var receiver in receivers) {
        await firebaseFirestore
            .collection('users')
            .doc(receiver.id)
            .collection('groupCalls')
            .add(newCall.toJson());
      }

      Future.delayed(Duration(seconds: 30), () {
        endGroupCall(newCall);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<GroupCallModel>> getGroupCallNotification() {
    return firebaseFirestore
        .collection('notification')
        .doc(auth.currentUser!.uid)
        .collection('groupCall')
        .snapshots()
        .map((snapshot) {
          log(
            '📥 Incoming Group Call Notification Data: ${snapshot.docs.length}',
          );
          return snapshot.docs
              .map((event) => GroupCallModel.fromJson(event.data()))
              .toList();
        });
  }

  Future<void> endGroupCall(GroupCallModel call) async {
    try {
      for (var participantId in call.participantUids!) {
        await firebaseFirestore
            .collection('notification')
            .doc(participantId)
            .collection('groupCall')
            .doc(call.id)
            .delete();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> groupAudioCallNotification(GroupCallModel callData) async {
    Get.snackbar(
      "Incoming Group Audio Call",
      "Group: ${callData.groupName}",
      duration: Duration(seconds: 15),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: Icon(Icons.call, color: Colors.green),
      mainButton: TextButton(
        onPressed: () {
          endGroupCall(callData);
          Get.back();
        },
        child: Text("End Call", style: TextStyle(color: Colors.red)),
      ),
      onTap: (snack) {
        Get.back();
        Get.to(GroupAudioCallPage(id: groupId));
      },
    );
  }

  void groupVideoCallNotification(GroupCallModel callData) {
    Get.snackbar(
      duration: Duration(seconds: 15),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: Icon(Icons.video_call),
      onTap: (snack) {
        Get.back();
        Get.to(GroupVideoCallPage(id: groupId));
      },
      callData.groupName!,
      "Incoming Group Video Call",
      mainButton: TextButton(
        onPressed: () {
          endGroupCall(callData);
          Get.back();
        },
        child: Text("End Call"),
      ),
    );
  }
}
