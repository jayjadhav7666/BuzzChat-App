import 'dart:developer';

import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/model/chatRoomModel.dart';
import 'package:buzzchat/pages/chat/chat_page.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    ContactController contactController = Get.put(ContactController());
    FirebaseAuth auth = FirebaseAuth.instance;
    Chatcontroller chatcontroller = Get.put(Chatcontroller());
    return StreamBuilder(
      stream: contactController.getChatRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<ChatRoomModel> list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.off(
                    ChatPage(
                      userModel:
                          list[index].receiver!.id == auth.currentUser!.uid
                              ? list[index].sender!
                              : list[index].receiver!,
                    ),
                  );
                },
                child: StreamBuilder(
                  stream: chatcontroller.getUnreadMessageCount(list[index].id!),
                  builder: (context, unreadsnapshot) {
                    int unreadCount = unreadsnapshot.data ?? 0;
                    log('$unreadCount');
                    return ChatTile(
                      imageUrl:
                          (list[index].receiver!.id == auth.currentUser!.uid
                              ? list[index].sender!.profileImage
                              : list[index].receiver!.profileImage) ??
                          AssetsImages.defaultIcons,
                      name:
                          (list[index].receiver!.id == auth.currentUser!.uid
                              ? list[index].sender!.name
                              : list[index].receiver!.name)!,
                      lastChat: list[index].lastMessage ?? '',
                      lastTime: list[index].lastMessageTimestamp!,
                      unreadCount: unreadCount,
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
