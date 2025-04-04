import 'package:buzzchat/config/strings.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Audiocallpage extends StatelessWidget {
  final UserModel target;
  const Audiocallpage({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.find<Profilecontroller>();
    Chatcontroller chatcontroller = Get.put(Chatcontroller());
    var callId = chatcontroller.getRoomId(target.id!);
    if (profilecontroller.currentUser.value.id == null ||
        profilecontroller.currentUser.value.name == null) {
      return Center(child: CircularProgressIndicator());
    }
    return ZegoUIKitPrebuiltCall(
      appID: ZegoCloudConfig.appId, // your AppID,
      appSign: ZegoCloudConfig.appSign,
      userID: profilecontroller.currentUser.value.id ?? 'root',
      userName: profilecontroller.currentUser.value.name ?? 'root',
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
