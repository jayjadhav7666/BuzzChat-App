import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/group/new%20group/group_title.dart';
import 'package:buzzchat/pages/group/new%20group/selectmember.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewGroup extends StatelessWidget {
  const NewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    ContactController contactController = Get.put(ContactController());
    Groupcontroller groupcontroller = Get.put(Groupcontroller());
    return Scaffold(
      appBar: AppBar(title: Text('New Group')),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor:
              groupcontroller.groupMember.isEmpty
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.primary,
          onPressed: () {
            if (groupcontroller.groupMember.isEmpty) {
              warningMessage('Please select at least one member');
            } else {
              Get.to(GroupTitle());
            }
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SelectMembers(),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Contacts on BuzzChat',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: contactController.getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No contacts found."));
                  }

                  List<UserModel> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GestureDetector(
                        onTap: () {
                          groupcontroller.selectMember(user);
                        },
                        child: ChatTile(
                          imageUrl:
                              user.profileImage ?? AssetsImages.defaultIcons,
                          name: user.name!,
                          lastChat: user.about!,
                          lastTime: '',
                          unreadCount: 0,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
