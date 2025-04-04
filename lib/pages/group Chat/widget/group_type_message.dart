import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupController.dart';
import 'package:buzzchat/controller/imagePicker.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GroupTypeMessage extends StatelessWidget {
  final GroupModel groupModel;
  const GroupTypeMessage({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    Groupcontroller groupcontroller = Get.find<Groupcontroller>();
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
                groupcontroller.selectedImagePath.value.isEmpty
                    ? GestureDetector(
                      onTap: () async {
                        mediaPickerBottomSheet(
                          context,
                          groupcontroller.selectedImagePath,
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
                        groupcontroller.selectedImagePath.value.isNotEmpty
                    ? GestureDetector(
                      onTap: () {
                        if (messageController.text.trim().isNotEmpty ||
                            groupcontroller
                                .selectedImagePath
                                .value
                                .isNotEmpty) {
                          groupcontroller.sendGroupMessage(
                            groupModel.id!,
                            messageController.text,
                            groupModel,
                          );
                          messageController.clear();
                          message.value = '';
                          groupcontroller.selectedImagePath.value = '';
                        }
                      },
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child:
                            groupcontroller.isLoading.value
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
