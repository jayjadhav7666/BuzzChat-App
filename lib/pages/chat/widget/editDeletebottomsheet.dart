import 'package:buzzchat/controller/chatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> editDeleteBottomSheet(
  BuildContext context,
  Chatcontroller chatController,
  String roomId,
  String chatId,
  String message,
) {
  return Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              "Edit Message",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Get.back();
              _editMessage(context, chatController, roomId, chatId, message);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              "Delete Message",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              chatController.deleteMessage(chatId, roomId);
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}

void _editMessage(
  BuildContext context,
  Chatcontroller chatController,
  String roomId,
  String chatId,
  String message,
) {
  TextEditingController messageController = TextEditingController(
    text: message,
  );

  Get.defaultDialog(
    title: "Edit Message",
    titleStyle: Theme.of(context).textTheme.bodyLarge,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    contentPadding: const EdgeInsets.all(10),
    titlePadding: const EdgeInsets.all(10),
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextField(
            controller: messageController,
            decoration: InputDecoration(hintText: "Enter new message"),
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text("Cancel", style: Theme.of(context).textTheme.labelLarge),
      ),
      const SizedBox(width: 20),
      ElevatedButton(
        onPressed: () {
          chatController.editMessage(chatId, roomId, messageController.text);
          Get.back();
        },
        child: Text("Save", style: Theme.of(context).textTheme.labelLarge),
      ),
    ],
  );
}
