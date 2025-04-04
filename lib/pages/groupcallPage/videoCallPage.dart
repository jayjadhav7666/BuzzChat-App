import 'package:buzzchat/config/strings.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class GroupVideoCallPage extends StatelessWidget {
  final String id;
  const GroupVideoCallPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.find<Profilecontroller>();

    if (profilecontroller.currentUser.value.id == null ||
        profilecontroller.currentUser.value.name == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId, // Your ZegoCloud App ID
      appSign: ZegoCloudConfig.appSign, // Your App Sign
      userID:
          profilecontroller.currentUser.value.id ?? 'root', // Unique User ID
      userName: profilecontroller.currentUser.value.name ?? 'root', // User Name
      callID: id, // Unique Group Call ID
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
    );
  }
}
