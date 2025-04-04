import 'dart:developer';
import 'dart:io';
import 'package:buzzchat/controller/imagePicker.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/pages/auth/widgets/primaryButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
 
    final TextEditingController name = TextEditingController(
      text: profilecontroller.currentUser.value.name,
    );

    final TextEditingController about = TextEditingController(
      text: profilecontroller.currentUser.value.about,
    );
    final TextEditingController email = TextEditingController(
      text: profilecontroller.currentUser.value.email,
    );
    final TextEditingController phone = TextEditingController(
      text: profilecontroller.currentUser.value.phoneNumber,
    );
    ImagePickerController imagePickerController = Get.put(
      ImagePickerController(),
    );
    RxString imagePath = ''.obs;
    RxBool isEdit = false.obs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Obx(
                          () =>
                              isEdit.value
                                  ? GestureDetector(
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
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                      child:
                                          imagePath.value.isEmpty
                                              ? profilecontroller
                                                              .currentUser
                                                              .value
                                                              .profileImage ==
                                                          null ||
                                                      profilecontroller
                                                              .currentUser
                                                              .value
                                                              .profileImage ==
                                                          ""
                                                  ? Icon(Icons.add, size: 40)
                                                  : CachedNetworkImage(
                                                    imageUrl:
                                                        profilecontroller
                                                            .currentUser
                                                            .value
                                                            .profileImage!,
                                                    fit: BoxFit.cover,

                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Center(
                                                          child: SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                              : Image.file(
                                                File(imagePath.value),
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  )
                                  : Container(
                                    height: 150,
                                    width: 150,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    child:
                                        profilecontroller
                                                        .currentUser
                                                        .value
                                                        .profileImage ==
                                                    null ||
                                                profilecontroller
                                                        .currentUser
                                                        .value
                                                        .profileImage ==
                                                    ""
                                            ? Icon(Icons.image, size: 40)
                                            : CachedNetworkImage(
                                              imageUrl:
                                                  profilecontroller
                                                      .currentUser
                                                      .value
                                                      .profileImage!,
                                              fit: BoxFit.cover,

                                              placeholder:
                                                  (context, url) => Center(
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                  ),
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () => TextField(
                            controller: name,
                            enabled: isEdit.value,

                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            decoration: InputDecoration(
                              filled: false,
                              labelText: "Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () => TextField(
                            controller: about,
                            enabled: isEdit.value,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            decoration: InputDecoration(
                              filled: false,
                              labelText: "About",
                              prefixIcon: Icon(
                                Icons.info,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        TextField(
                          controller: email,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          decoration: InputDecoration(
                            filled: false,
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Obx(
                          () => TextField(
                            controller: phone,
                            enabled: isEdit.value,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            decoration: InputDecoration(
                              filled: false,
                              labelText: "Number",
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () =>
                              profilecontroller.isLoading.value
                                  ? CircularProgressIndicator()
                                  : isEdit.value
                                  ? SizedBox(
                                    width: 165,
                                    child: Primarybutton(
                                      name: 'Save',
                                      icon: Icons.save,
                                      onTap: () async {
                                        log('add');
                                        await profilecontroller.updateProfile(
                                          name.text.trim(),
                                          about.text.trim(),
                                          imagePath.value,
                                          phone.text.trim(),
                                        );
                                        isEdit.value = false;
                                      },
                                    ),
                                  )
                                  : SizedBox(
                                    width: 165,
                                    child: Primarybutton(
                                      name: 'Edit',
                                      icon: Icons.edit,
                                      onTap: () {
                                        isEdit.value = true;
                                      },
                                    ),
                                  ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
