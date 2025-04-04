import 'dart:developer';
import 'dart:io';

import 'package:buzzchat/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class Profilecontroller extends GetxController {
  Rx<UserModel> currentUser = UserModel().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  RxBool isLoading = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await getUserData();
  }

  Future<void> getUserData() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then(
          (value) => {currentUser.value = UserModel.fromJson(value.data()!)},
        );
  }

  Future<void> updateProfile(
    String name,
    String about,
    String imageUrl,
    String number,
  ) async {
    isLoading.value = true;

    var imageLink = await uploadImageandDownloadUrl(imageUrl);

    var updateUser = UserModel(
      id: auth.currentUser!.uid,
      name: name,
      about: about,
      email: auth.currentUser!.email,
      phoneNumber: number,
      profileImage:
          imageUrl.isEmpty ? currentUser.value.profileImage : imageLink,
      createdAt: currentUser.value.createdAt,
      status: currentUser.value.status,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update(updateUser.toJson());
    await getUserData();

    isLoading.value = false;
  }

  Future<String> uploadImageandDownloadUrl(String imageUrl) async {
    try {
      String fileName =
          '${auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String path = 'UserImage/$fileName';
      await firebaseStorage.ref().child(path).putFile(File(imageUrl));
      var imageLink = await firebaseStorage.ref().child(path).getDownloadURL();
      return imageLink;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
