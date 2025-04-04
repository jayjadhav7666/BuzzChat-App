import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/searchController.dart';
import 'package:buzzchat/model/chatRoomModel.dart';
import 'package:buzzchat/model/groupModel.dart';

import 'package:buzzchat/pages/chat/chat_page.dart';
import 'package:buzzchat/pages/group%20Chat/group_chat.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchChatPage extends StatefulWidget {
  const SearchChatPage({super.key});

  @override
  State<SearchChatPage> createState() => _SearchChatPageState();
}

class _SearchChatPageState extends State<SearchChatPage> {
  final TextEditingController searchTextController = TextEditingController();
  RxString searchText = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SearchChatController searchChatController = Get.put(SearchChatController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: searchTextController,
                  autofocus: true,
                  onChanged: (value) {
                    searchText.value = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search ...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(), // Cancel button
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return StreamBuilder(
            stream:
                searchText.value.isEmpty
                    ? searchChatController.getAllChatsAndGroups()
                    : searchChatController.searchAllChats(searchText.value),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No results found"));
              }

              var list = snapshot.data!;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];

                  // Extract common properties
                  String name =
                      item is ChatRoomModel
                          ? (item.receiver!.id == auth.currentUser!.uid
                              ? item.sender!.name
                              : item.receiver!.name)!
                          : (item as GroupModel).name!;

                  String profileImage =
                      item is ChatRoomModel
                          ? (item.receiver!.id == auth.currentUser!.uid
                                  ? item.sender!.profileImage
                                  : item.receiver!.profileImage) ??
                              AssetsImages.defaultIcons
                          : (item as GroupModel).profileUrl ??
                              AssetsImages.defaultIcons;

                  String lastMessage =
                      item is ChatRoomModel
                          ? item.lastMessage ?? ''
                          : (item as GroupModel).lastMessage ??
                              ''; // Default text for groups

                  String? lastTime =
                      item is ChatRoomModel
                          ? item.lastMessageTimestamp ?? ''
                          : (item as GroupModel).lastMessageTime ??
                              ''; // Groups might not have timestamps

                  return GestureDetector(
                    onTap: () {
                      if (item is ChatRoomModel) {
                        Get.off(
                          ChatPage(
                            userModel:
                                item.receiver!.id == auth.currentUser!.uid
                                    ? item.sender!
                                    : item.receiver!,
                          ),
                        );
                      } else if (item is GroupModel) {
                        Get.off(GroupChatPage(groupModel: item));
                      }
                    },
                    child: ChatTile(
                      imageUrl: profileImage,
                      name: name,
                      lastChat: lastMessage,
                      lastTime: lastTime,
                      unreadCount: 0,
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
