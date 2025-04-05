
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> editDeleteGroupBottomSheet(
  BuildContext context,
  Groupcontroller groupController,
  String groupId,
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
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              "Edit Message",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Get.back();
              _editMessage(context, groupController, groupId, chatId, message);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              "Delete Message",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              groupController.deleteGroupMessage(chatId, groupId);
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
  Groupcontroller groupController,
  String groupId,
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
          groupController.editGroupMessage(
            chatId,
            groupId,
            messageController.text,
          );
          Get.back();
        },
        child: Text("Save", style: Theme.of(context).textTheme.labelLarge),
      ),
    ],
  );
}
