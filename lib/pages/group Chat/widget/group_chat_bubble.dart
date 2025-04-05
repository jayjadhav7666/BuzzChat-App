import 'dart:io';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/pages/group%20Chat/widget/editDeleteGroupChat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reaction_askany/models/emotions.dart';
import 'package:reaction_askany/models/reaction_box_paramenters.dart';
import 'package:reaction_askany/reaction_askany.dart';

class GroupChatBubble extends StatelessWidget {
  final String chatId;
  final String groupId;
  final List<String>? reactions;
  final String senderName;
  final String message;
  final String senderId;
  final String imageUrl;
  final String time;
  final bool isComming;
  final String status;
  const GroupChatBubble({
    super.key,
    required this.message,
    required this.imageUrl,
    required this.time,
    required this.isComming,
    required this.status,
    required this.chatId,
    required this.groupId,
    this.reactions,
    required this.senderName,
    required this.senderId,
  });
  Future<String?> getProfileImage() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(senderId)
              .get();
      return userDoc['profileImage']; // Ensure 'profileImage' exists in Firestore
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Get.find<Groupcontroller>();
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    return GestureDetector(
      onLongPress: () {
        if (senderId == profilecontroller.currentUser.value.id) {
          editDeleteGroupBottomSheet(
            context,
            groupController,
            groupId,
            chatId,
            message,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment:
              isComming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            ReactionWrapper(
              doubleTapLabel: "",
              handlePressed: (selectedEmotion) async {
                String reaction = selectedEmotion.toString();
                await groupController.addReaction(chatId, reaction, groupId);
              },
              handlePressedReactions: () async {
                await groupController.removeGroupMessageReaction(
                  chatId,
                  groupId,
                );
              },
              initialEmotion:
                  (reactions != null && reactions!.isNotEmpty
                      ? parseEmotion(reactions![0])
                      : null),
              boxParamenters: ReactionBoxParamenters(
                brightness: Theme.of(context).brightness,
                iconSize: 30,
                iconSpacing: 10,
                paddingHorizontal: 30,
                radiusBox: 40,
                quantityPerPage: 10,
              ),
              // Providing an empty widget for buttonReaction hides any persistent reaction button.
              buttonReaction: const SizedBox.shrink(),
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius:
                      isComming
                          ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(10),
                          )
                          : const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(0),
                          ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isComming
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 5),
                          child: FutureBuilder(
                            future: getProfileImage(),
                            builder: (context, snapshot) {
                              String? profileUrl = snapshot.data;
                              return SizedBox(
                                width: imageUrl.isEmpty ? 140 : double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 22,
                                      width: 22,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        profileUrl ?? AssetsImages.defaultIcons,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    SizedBox(
                                      width: imageUrl.isEmpty ? 110 : 200,
                                      child: Text(
                                        senderName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox(),
                    imageUrl.isEmpty
                        ? Text(message)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display image with tap to view full screen.
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  FullScreenImage(
                                    imageUrl: imageUrl,
                                    message: message.isNotEmpty ? message : '',
                                  ),
                                );
                              },
                              child: Hero(
                                tag: imageUrl,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 330,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      imageUrl.startsWith("http")
                                          ? CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Center(
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                          : Image.file(File(imageUrl)),
                                ),
                              ),
                            ),
                            message == "" ? Container() : SizedBox(height: 10),
                            message == "" ? Container() : Text(message),
                          ],
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment:
                  isComming ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                isComming
                    ? Text(time, style: Theme.of(context).textTheme.labelMedium)
                    : Row(
                      children: [
                        Text(
                          time,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          AssetsImages.chatStatusSvg,
                          colorFilter: ColorFilter.mode(
                            status == "read" ? Colors.green : Colors.grey,
                            BlendMode.srcIn,
                          ),
                          width: 20,
                        ),
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Emotions? parseEmotion(String reaction) {
    switch (reaction) {
      case "Emotions.love":
        return Emotions.love;
      case "Emotions.like":
        return Emotions.like;
      case "Emotions.haha":
        return Emotions.haha;
      case "Emotions.wow":
        return Emotions.wow;
      case "Emotions.angry":
        return Emotions.angry;
      case "Emotions.care":
        return Emotions.care;
      default:
        return null;
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String message;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Centered Image
          Center(
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder:
                    (context, url) => const CircularProgressIndicator(),
                errorWidget:
                    (context, url, error) =>
                        const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),

          // Message Positioned at the Bottom Always
          if (message.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
