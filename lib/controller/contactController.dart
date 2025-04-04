import 'dart:developer';

import 'package:buzzchat/model/chatRoomModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxString searchUsername = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getUserList();
    getChatRoom();
  }

  Stream<List<UserModel>> getUserList() {
    return firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<UserModel>> searchUser(String name) {
    return firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where(
            (user) => user.name!.toLowerCase().contains(name.toLowerCase()),
          )
          .toList();
    });
  }

  //new module for when userchange dp or name about this update data in firebase thats why make changes in code
  Stream<List<ChatRoomModel>> getChatRoom() {
    update();
    return firestore
        .collection('chats')
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshots) {
          return snapshots.docs
              .map((doc) {
                // Convert to ChatRoomModel
                var chatRoom = ChatRoomModel.fromJson(doc.data());

                // Update the sender or receiver info if needed
                if (chatRoom.receiver!.id == auth.currentUser!.uid) {
                  getUserDetails(chatRoom.sender!.id!).listen((user) {
                    // Update receiver's user data
                    chatRoom.receiver = user;
                  });
                } else {
                  getUserDetails(chatRoom.receiver!.id!).listen((user) {
                    // Update sender's user data
                    chatRoom.sender = user;
                  });
                }

                return chatRoom;
              })
              .where((chatRoom) => chatRoom.id!.contains(auth.currentUser!.uid))
              .toList();
        });
  }

  Stream<UserModel> getUserDetails(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  Future<void> saveContact(UserModel user) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('contacts')
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Stream<List<UserModel>> getContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('contacts')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((event) => UserModel.fromJson(event.data()))
              .toList();
        });
  }

 
}
