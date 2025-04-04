import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/chat/chat_page.dart';
import 'package:buzzchat/pages/contactPage/widget/contact_Serach.dart';
import 'package:buzzchat/pages/contactPage/widget/new_contact_tile.dart';
import 'package:buzzchat/pages/group/new%20group/new_group.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isSearch = false.obs;
    ContactController contactController = Get.put(ContactController());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Select contact',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                isSearch.value = !isSearch.value;
              },
              icon: Icon(isSearch.value ? Icons.close : Icons.search, size: 26),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(
              () => isSearch.value ? const ContactSearch() : const SizedBox(),
            ),

            Obx(
              () =>
                  isSearch.value
                      ? const SizedBox()
                      : Column(
                        children: [
                          const SizedBox(height: 10),

                          // New Contact & New Group
                          NewContactTile(
                            btname: "New Contact",
                            icon: Icons.person_add,
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          NewContactTile(
                            btname: "New Group",
                            icon: Icons.group_add,
                            onTap: () {
                              Get.to(NewGroup());
                            },
                          ),
                          const SizedBox(height: 15),

                          // Contacts Label
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Contacts on BuzzChat',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
            ),
            const SizedBox(height: 15),

            // User List
            Expanded(
              child: Obx(
                () => StreamBuilder<List<UserModel>>(
                  stream:
                      isSearch.value
                          ? contactController.searchUser(
                            contactController.searchUsername.value,
                          )
                          : contactController.getUserList(),
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
                            if (auth.currentUser!.uid != user.id) {
                              Get.to(() => ChatPage(userModel: user));
                            }
                          },
                          child: ChatTile(
                            imageUrl:
                                user.profileImage ?? AssetsImages.defaultIcons,
                            name: user.name!,
                            lastChat: user.about!,
                            lastTime:
                                user.email ==
                                        profilecontroller
                                            .currentUser
                                            .value
                                            .email
                                    ? "You"
                                    : "",
                            unreadCount: 0,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
