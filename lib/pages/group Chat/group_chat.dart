import 'dart:io';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupCallController.dart';
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/group%20Chat/widget/group_chat_bubble.dart';
import 'package:buzzchat/pages/group%20Chat/widget/group_type_message.dart';
import 'package:buzzchat/pages/group%20info/group_detail.dart';
import 'package:buzzchat/pages/groupcallPage/audioCallPage.dart';
import 'package:buzzchat/pages/groupcallPage/videoCallPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatefulWidget {
  final GroupModel groupModel;
  const GroupChatPage({super.key, required this.groupModel});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Groupcontroller groupcontroller = Get.put(Groupcontroller());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    GroupCallController groupCallController = Get.put(GroupCallController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  GroupInfoPage(
                    groupModel: widget.groupModel,
                    groupId: widget.groupModel.id!,
                  ),
                );
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
                            widget.groupModel.profileUrl ??
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
                          widget.groupModel.name!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
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
              // Create a new list excluding the caller
              List<UserModel> participants =
                  widget.groupModel.members!
                      .where(
                        (member) =>
                            member.id != profilecontroller.currentUser.value.id,
                      )
                      .toList();
              await groupCallController.initiateGroupCall(
                participants,
                profilecontroller.currentUser.value,
                'audio',
                widget.groupModel,
              );
              Get.to(GroupAudioCallPage(id: widget.groupModel.id!));
            },
            icon: Icon(Icons.phone, size: 22),
          ),
          IconButton(
            onPressed: () async {
              // Create a new list excluding the caller
              List<UserModel> participants =
                  widget.groupModel.members!
                      .where(
                        (member) =>
                            member.id != profilecontroller.currentUser.value.id,
                      )
                      .toList();
              await groupCallController.initiateGroupCall(
                participants,
                profilecontroller.currentUser.value,
                'video',
                widget.groupModel,
              );
              Get.to(GroupVideoCallPage(id: widget.groupModel.id!));
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
                    stream: groupcontroller.getGroupMessages(
                      widget.groupModel.id!,
                    ),
                    builder: (context, snapshot) {
                      groupcontroller.markGroupMessagesAsRead(
                        widget.groupModel.id!,
                      );
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

                            return GroupChatBubble(
                              chatId: chatModel.id!,
                              senderId: snapshot.data![index].senderId!,
                              groupId: widget.groupModel.id!,
                              reactions: snapshot.data![index].reactions,
                              message: snapshot.data![index].message!,
                              imageUrl: snapshot.data![index].imageUrl ?? '',
                              time: formattedTime,
                              senderName: snapshot.data![index].senderName!,
                              isComming:
                                  snapshot.data![index].senderId !=
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
                        groupcontroller.selectedImagePath.value.isNotEmpty
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
                                              groupcontroller
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
                                        groupcontroller
                                            .selectedImagePath
                                            .value = '';
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
            GroupTypeMessage(groupModel: widget.groupModel),
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
