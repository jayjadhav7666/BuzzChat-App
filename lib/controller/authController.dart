import 'dart:developer';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/controller/statusController.dart';
import 'package:buzzchat/data/apiexception.dart';
import 'package:buzzchat/data/notification_services.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Statuscontroller statuscontroller = Get.put(Statuscontroller());
  RxBool isLoading = false.obs;
  NotificationServices notificationServices = NotificationServices();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Log In
  Future<void> logIn(String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? token = await notificationServices.getDeviceToken();
      await firestore.collection('users').doc(userCredential.user!.uid).update({
        'userDeviceToken': token,
      });
      successMessage('Successfully login');
      Get.offAllNamed("/homePage");
    } on FirebaseAuthException catch (e) {
      ApiException exception = _handleFirebaseAuthException(e);
      errorMessage(exception.message);
    } catch (e) {
      errorMessage("An unexpected error occurred.");
      log(e.toString());
    }
    isLoading.value = false;
  }

  // Create User
  Future<void> createUser(String name, String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? token = await notificationServices.getDeviceToken();

      String createdTime = DateTime.now().toString();
      var userData = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        about: 'Hey there, I am using BuzzChat',
        createdAt: createdTime,
        userDeviceToken: token,
      );
      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());
      successMessage('Account created Successfully');
      Get.offAllNamed("/homePage");
    } on FirebaseAuthException catch (e) {
      ApiException exception = _handleFirebaseAuthException(e);
      errorMessage(exception.message);
    } catch (e) {
      errorMessage("An unexpected error occurred.");
      log(e.toString());
    }
    isLoading.value = false;
  }

  // Log Out
  Future<void> logOut() async {
    String lastSeen = statuscontroller.formatStatusSeen(DateTime.now());
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'status': lastSeen,
    });
    await auth.signOut();

    Get.offAllNamed('/authPage');
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await auth.sendPasswordResetEmail(email: email);
      successMessage('Email sent. Please check your mail.');
    } on FirebaseAuthException catch (e) {
      ApiException exception = _handleFirebaseAuthException(e);
      errorMessage(exception.message);
    } catch (ex) {
      errorMessage("Failed to send reset email.");
    }
    isLoading.value = false;
  }

  // Exception Handling for FirebaseAuthException
  ApiException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-credential":
        return BadRequestException('Invalid Email & Password');
      case "user-not-found":
        return UnauthorizedException('User Not Found');
      case "wrong-password":
        return UnauthorizedException('Wrong Password. Please try again.');
      case 'network-request-failed':
        return InternetException('No Internet Connection');
      case "email-already-in-use":
        return BadRequestException('Email Already In Use');
      case 'too-many-requests':
        return RequestTimeoutException('Too many requests. Try again later.');
      default:
        log(e.code);
        return FetchDataException('An error occurred: ${e.code}');
    }
  }
}
