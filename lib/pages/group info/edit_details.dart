
import 'dart:developer';
import 'dart:io';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/controller/groupController.dart';
import 'package:buzzchat/controller/imagePicker.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/pages/auth/widgets/primaryButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void showUpdateGroupDialog(BuildContext context, GroupModel groupModel) {
  Groupcontroller groupcontroller = Get.put(Groupcontroller());
  final TextEditingController groupname = TextEditingController(
    text: groupModel.name,
  );
  final TextEditingController description = TextEditingController(
    text: groupModel.description,
  );
  ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );
  RxString oldImage = groupModel.profileUrl!.obs;
  RxString imagePath = ''.obs;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(18),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Update Group Profile',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 26,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    imagePath.value =
                        (await imagePickerController.getImage(
                          ImageSource.gallery,
                        ))!;
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child:
                        imagePath.value.isEmpty
                            ? CachedNetworkImage(
                              imageUrl: oldImage.value,
                              fit: BoxFit.cover,

                              placeholder:
                                  (context, url) => Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Icon(Icons.error),
                            )
                            : Image.file(
                              File(imagePath.value),
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: groupname,
                decoration: InputDecoration(
                  labelText: "Group Name",
                  prefixIcon: Icon(Icons.group),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Primarybutton(
                  name: 'Update',
                  icon: Icons.save,
                  onTap: () async {
                    log(groupModel.profileUrl!);
                    String imageUrl = oldImage.value;
                    if (imagePath.value.isNotEmpty) {
                      imageUrl = imagePath.value;
                    }
                    await groupcontroller
                        .updateGroup(
                          groupModel.id!,
                          groupname.text.trim(),
                          imageUrl,
                          description.text.trim(),
                        )
                        .then((value) {
                          successMessage('Group profile updated.');
                          Get.back();
                        });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
