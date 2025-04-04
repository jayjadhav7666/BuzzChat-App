import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Statuscontroller extends GetxController with WidgetsBindingObserver {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'status': 'Online',
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      String lastSeen = formatStatusSeen(DateTime.now());
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'status': lastSeen,
      });
    } else if (state == AppLifecycleState.resumed) {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'status': 'Online',
      });
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  String formatStatusSeen(DateTime lastSeen) {
    DateTime now = DateTime.now();
    String time = DateFormat('hh:mm a').format(lastSeen);

    if (lastSeen.day == now.day) {
      return 'Last seen at $time';
    } else if (lastSeen.day == now.subtract(Duration(days: 1)).day) {
      return 'Last seen yesterday at $time';
    } else {
      return 'Last seen on ${DateFormat('EEEE hh:mm a').format(lastSeen)}';
    }
  }
}
