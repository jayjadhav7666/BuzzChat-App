import 'package:buzzchat/config/strings.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class GroupAudioCallPage extends StatelessWidget {
  final String id;
  const GroupAudioCallPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.find<Profilecontroller>();

    if (profilecontroller.currentUser.value.id == null ||
        profilecontroller.currentUser.value.name == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId, // Your Zego AppID
      appSign: ZegoCloudConfig.appSign,
      userID: profilecontroller.currentUser.value.id ?? 'root',
      userName: profilecontroller.currentUser.value.name ?? 'root',
      callID: id,
      config: ZegoUIKitPrebuiltCallConfig.groupVoiceCall(),
    );
  }
}
