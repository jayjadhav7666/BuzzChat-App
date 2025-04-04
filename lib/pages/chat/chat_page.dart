import 'dart:io';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/callController.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/callPage/audioCallPage.dart';
import 'package:buzzchat/pages/callPage/videoCallPage.dart';
import 'package:buzzchat/pages/chat/widget/chat_bubble.dart';
import 'package:buzzchat/pages/chat/widget/type_message.dart';
import 'package:buzzchat/pages/userProfile/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  const ChatPage({super.key, required this.userModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Chatcontroller chatcontroller = Get.put(Chatcontroller());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    Callcontroller callcontroller = Get.put(Callcontroller());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  Get.offAllNamed('/homePage');
                },
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(UserProfilePage(userModel: widget.userModel));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      height: 40,
                      width: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                        imageUrl:
                            widget.userModel.profileImage ??
                            AssetsImages.defaultIcons,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 142,
                        child: Text(
                          widget.userModel.name!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      SizedBox(
                        width: 142,
                        child: StreamBuilder(
                          stream: chatcontroller.getStatus(
                            widget.userModel.id!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(color: Colors.grey),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text(
                                "Offline",
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(color: Colors.red),
                              );
                            }
                            return Text(
                              snapshot.data!.status ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall!.copyWith(
                                color:
                                    snapshot.data!.status == 'Online'
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await callcontroller.callAction(
                widget.userModel,
                profilecontroller.currentUser.value,
                'audio',
              );
              Get.to(Audiocallpage(target: widget.userModel));
            },
            icon: Icon(Icons.phone, size: 22),
          ),
          IconButton(
            onPressed: () async {
              await callcontroller.callAction(
                widget.userModel,
                profilecontroller.currentUser.value,
                'video',
              );
              Get.to(Videocallpage(target: widget.userModel));
            },
            icon: Icon(Icons.video_call, size: 22),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: chatcontroller.getMessage(widget.userModel.id!),
                    builder: (context, snapshot) {
                      var roomId = chatcontroller.getRoomId(
                        widget.userModel.id!,
                      );
                      //for read message
                      chatcontroller.markMessagesAsRead(roomId);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      }

                      if (snapshot.data == null) {
                        return Center(child: Text('No Message'));
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scrollToBottom();
                        });
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            DateTime timeStamp = DateTime.parse(
                              snapshot.data![index].timestamp!,
                            );
                            String formattedTime = DateFormat(
                              'hh:mm a',
                            ).format(timeStamp);
                            final chatModel = snapshot.data![index];
                            final roomId = chatcontroller.getRoomId(
                              widget.userModel.id!,
                            );
                            return ChatBubble(
                              chatId: chatModel.id!,
                              roomId: roomId,
                              reactions: snapshot.data![index].reactions,
                              message: snapshot.data![index].message!,
                              imageUrl: snapshot.data![index].imageUrl ?? '',
                              time: formattedTime,
                              isComming:
                                  snapshot.data![index].receiverId ==
                                  profilecontroller.currentUser.value.id,
                              status: snapshot.data![index].readStatus!,
                            );
                          },
                        );
                      }
                    },
                  ),
                  //for showing selected Image
                  Obx(
                    () =>
                        chatcontroller.selectedImagePath.value.isNotEmpty
                            ? Positioned(
                              bottom: 0,
                              left: 5,
                              right: 5,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 400,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                    ),

                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(
                                              chatcontroller
                                                  .selectedImagePath
                                                  .value,
                                            ),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        chatcontroller.selectedImagePath.value =
                                            '';
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(),
                  ),
                ],
              ),
            ),
            TypeMessage(userModel: widget.userModel),
          ],
        ),
      ),
    );
  }

  // Scroll to bottom function
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}
