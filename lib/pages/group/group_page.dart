import 'package:buzzchat/controller/groupController.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/pages/group%20Chat/group_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/widget/chat_tile.dart';

class GroupPageScren extends StatefulWidget {
  const GroupPageScren({super.key});

  @override
  State<GroupPageScren> createState() => _GroupPageScrenState();
}

class _GroupPageScrenState extends State<GroupPageScren> {
  @override
  Widget build(BuildContext context) {
    Groupcontroller groupcontroller = Get.put(Groupcontroller());
    return Scaffold(
      body: StreamBuilder(
        stream: groupcontroller.getGroupss(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<GroupModel> groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                GroupModel group = groups[index];
                return StreamBuilder(
                  stream: groupcontroller.getGroupUnreadMessageCount(group.id!),
                  builder: (context, unreadsnapshot) {
                    int unreadCount = unreadsnapshot.data ?? 0;
                    return GestureDetector(
                      onTap: () {
                        Get.to(GroupChatPage(groupModel: group));
                      },
                      child: ChatTile(
                        imageUrl: group.profileUrl!,
                        name: group.name!,
                        lastChat: group.lastMessage ?? '',
                        lastTime: group.lastMessageTime ?? '',
                        unreadCount: unreadCount,
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
