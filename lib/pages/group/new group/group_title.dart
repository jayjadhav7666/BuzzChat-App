import 'dart:io';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:buzzchat/controller/imagePicker.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GroupTitle extends StatelessWidget {
  const GroupTitle({super.key});

  @override
  Widget build(BuildContext context) {
    Groupcontroller groupcontroller = Get.put(Groupcontroller());
    ImagePickerController imagePickerController = Get.put(
      ImagePickerController(),
    );
    RxString description = ''.obs;
    RxString groupName = ''.obs;
    RxString imagePath = ''.obs;
    return Scaffold(
      appBar: AppBar(title: Text('New Group')),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor:
              groupName.value.isEmpty
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.primary,
          onPressed: () {
            if (groupName.value.isEmpty) {
              warningMessage('Please enter group name');
            } else {
              groupcontroller.createGroup(
                groupName.value,
                imagePath.value,
                description: description.value,
              );
            }
          },
          child:
              groupcontroller.isLoading.value == true
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                  : Icon(Icons.done),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
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
                                  imagePath.value == ''
                                      ? Icon(Icons.group, size: 50)
                                      : Image.file(
                                        File(imagePath.value),
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            groupName.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Group Name",
                            prefixIcon: Icon(Icons.group),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            description.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Group Description",
                            prefixIcon: Icon(Icons.note),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      groupcontroller.groupMember
                          .map(
                            (e) => ChatTile(
                              imageUrl:
                                  e.profileImage ?? AssetsImages.defaultIcons,
                              name: e.name!,
                              lastChat: e.about!,
                              lastTime: '',
                              unreadCount: 0,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
