import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/controller/imagePicker.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TypeMessage extends StatelessWidget {
  final UserModel userModel;
  const TypeMessage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    Chatcontroller chatcontroller = Get.put(Chatcontroller());
    ImagePickerController imagePickerController = Get.put(
      ImagePickerController(),
    );
    RxString message = ''.obs;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: SvgPicture.asset(AssetsImages.chatEmoji, width: 25),
          ),

          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: (val) {
                message.value = val;
              },
              decoration: const InputDecoration(
                filled: false,
                hintText: "Type message ...",
              ),
            ),
          ),
          Obx(
            () =>
                chatcontroller.selectedImagePath.value.isEmpty
                    ? GestureDetector(
                      onTap: () async {
                        mediaPickerBottomSheet(
                          context,
                          chatcontroller.selectedImagePath,
                          imagePickerController,
                        );
                      },
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SvgPicture.asset(
                          AssetsImages.chatGallarySvg,
                          width: 25,
                        ),
                      ),
                    )
                    : SizedBox(),
          ),
          const SizedBox(width: 10),
          Obx(
            () =>
                message.value.isNotEmpty ||
                        chatcontroller.selectedImagePath.value.isNotEmpty
                    ? GestureDetector(
                      onTap: () {
                        if (messageController.text.trim().isNotEmpty ||
                            chatcontroller.selectedImagePath.value.isNotEmpty) {
                          chatcontroller.sendMessage(
                            userModel.id!,
                            messageController.text,
                            userModel,
                          );
                          messageController.clear();
                          message.value = '';
                          chatcontroller.selectedImagePath.value = '';
                        }
                      },
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child:
                            chatcontroller.isLoading.value
                                ? CircularProgressIndicator()
                                : SvgPicture.asset(
                                  AssetsImages.chatSendSvg,
                                  width: 25,
                                ),
                      ),
                    )
                    : SizedBox(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        AssetsImages.chatMicSvg,
                        width: 25,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
