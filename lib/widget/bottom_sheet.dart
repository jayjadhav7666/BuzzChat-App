import 'package:buzzchat/controller/imagePicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> mediaPickerBottomSheet(BuildContext context, RxString imagePath,
    ImagePickerController imagePickerController) {
  return Get.bottomSheet(
    Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              pickMedia(
                context,
                icon: Icons.camera,
                label: 'Camera',
                onTap: () async {
                  imagePath.value =
                      (await imagePickerController.getImage(ImageSource.camera))!;
                  Get.back();
                },
              ),
              pickMedia(
                context,
                icon: Icons.photo,
                label: 'Gallery',
                onTap: () async {
                  imagePath.value =
                      (await imagePickerController.getImage(ImageSource.gallery))!;
                  Get.back();
                },
              ), pickMedia(
                context,
                icon: Icons.play_arrow,
                label: 'Video',
                onTap: () {
                  // Implement video picking logic
                },
              ),
           
      
          pickMedia(
            context,
            icon: Icons.contacts,
            label: 'Contact',
            onTap: () {
              // Implement contact picking logic
            },
          ),
             
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              pickMedia(
                context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                onTap: () {
                  // Implement document picking logic
                },
              ),  pickMedia(
            context,
            icon: Icons.audiotrack,
            label: 'Audio',
            onTap: () {
              // Implement audio picking logic
            },
          ),    pickMedia(
            context,
            icon: Icons.location_on,
            label: 'Location',
            onTap: () {
              // Implement location sharing logic
            },
          ),
             
            ],
          ),
        ],
      ),
    ),
  );
}

Widget pickMedia(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            size: 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    ),
  );
}
