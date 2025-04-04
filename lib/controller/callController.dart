import 'dart:developer';

import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/callModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/callPage/audioCallPage.dart';
import 'package:buzzchat/pages/callPage/videoCallPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Callcontroller extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid().v4();
  Profilecontroller profilecontroller = Get.put(Profilecontroller());

  @override
  void onInit() {
    super.onInit();
    getCallNotification().listen((List<CallModel> callList) {
      if (callList.isNotEmpty) {
        var callData = callList[0];
        if (callData.type == "audio") {
          audioCallNotification(callData);
        } else if (callData.type == "video") {
          videoCallNotification(callData);
        }
      }
    });
  }

  Future<void> fetchData() async {
    getCallNotification().listen((List<CallModel> callList) {
      log('📞 Callcontroller detected new call');
      audioCallNotification(callList[0]);
      if (callList.isNotEmpty) {
        var callData = callList[0];
        if (callData.type == "audio") {
          log("🎵 Showing audio call notification");
          audioCallNotification(callData);
        } else if (callData.type == "video") {
          log("📹 Showing video call notification");
          videoCallNotification(callData);
        }
      } else {
        log('empty');
      }
    });
  }

  Future<void> callAction(
    UserModel reciver,
    UserModel caller,
    String type,
  ) async {
    String id = uuid;
    DateTime timestamp = DateTime.now();
    String nowTime = DateFormat('hh:mm a').format(timestamp);
    var newCall = CallModel(
      id: id,
      callerName: caller.name,
      callerPic: caller.profileImage,
      callerUid: caller.id,
      callerEmail: caller.email,
      receiverName: reciver.name,
      receiverPic: reciver.profileImage,
      receiverUid: reciver.id,
      receiverEmail: reciver.email,
      status: 'dialing',
      time: nowTime,
      type: type,
      timestamp: DateTime.now().toString(),
    );

    try {
      await firebaseFirestore
          .collection('notification')
          .doc(reciver.id)
          .collection('call')
          .doc(id)
          .set(newCall.toJson());
      //used for store call history
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('calls')
          .add(newCall.toJson());

      await firebaseFirestore
          .collection('users')
          .doc(reciver.id)
          .collection('calls')
          .add(newCall.toJson());

      Future.delayed(Duration(seconds: 20), () {
        endCall(newCall);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<CallModel>> getCallNotification() {
    return firebaseFirestore
        .collection('notification')
        .doc(auth.currentUser!.uid)
        .collection('call')
        .snapshots()
        .map((snapshot) {
          log('📥 Incoming Call Notification Data: ${snapshot.docs.length}');
          return snapshot.docs
              .map((event) => CallModel.fromJson(event.data()))
              .toList();
        });
  }

  Future<void> endCall(CallModel call) async {
    try {
      await firebaseFirestore
          .collection('notification')
          .doc(call.receiverUid)
          .collection('call')
          .doc(call.id)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> audioCallNotification(CallModel callData) async {
    Get.snackbar(
      "Incoming Audio Call",
      "From: ${callData.callerName}",
      duration: Duration(seconds: 10),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: Icon(Icons.call, color: Colors.green),
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: Text("End Call", style: TextStyle(color: Colors.red)),
      ),
      onTap: (snack) {
        Get.back();
        Get.to(
          Audiocallpage(
            target: UserModel(
              id: callData.callerUid,
              name: callData.callerName,
              email: callData.callerEmail,
              profileImage: callData.callerPic,
            ),
          ),
        );
      },
    );
  }

  void videoCallNotification(CallModel callData) {
    Get.snackbar(
      duration: Duration(seconds: 10),
      barBlur: 0,
      backgroundColor: Colors.grey[900]!,
      isDismissible: false,
      icon: Icon(Icons.video_call),
      onTap: (snack) {
        Get.back();
        Get.to(
          Videocallpage(
            target: UserModel(
              id: callData.callerUid,
              name: callData.callerName,
              email: callData.callerEmail,
              profileImage: callData.callerPic,
            ),
          ),
        );
      },
      callData.callerName!,
      "Incoming Video Call",
      mainButton: TextButton(
        onPressed: () {
          endCall(callData);
          Get.back();
        },
        child: Text("End Call"),
      ),
    );
  }
}
