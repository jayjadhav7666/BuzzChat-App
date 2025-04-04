import 'dart:io';

import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/pages/chat/widget/editDeletebottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reaction_askany/models/emotions.dart';
import 'package:reaction_askany/models/reaction_box_paramenters.dart';
import 'package:reaction_askany/reaction_askany.dart';

class ChatBubble extends StatelessWidget {
  final String chatId;
  final String roomId;
  final List<String>? reactions;
  final String message;
  final String imageUrl;
  final String time;
  final bool isComming;
  final String status;
  const ChatBubble({
    super.key,
    required this.message,
    required this.imageUrl,
    required this.time,
    required this.isComming,
    required this.status,
    required this.chatId,
    required this.roomId,
    this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(Chatcontroller());

    return GestureDetector(
      onLongPress: () {
        editDeleteBottomSheet(context, chatController, roomId, chatId, message);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment:
              isComming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            ReactionWrapper(
              doubleTapLabel: "",
              handlePressed: (selectedEmotion) async {
                String reaction = selectedEmotion.toString();
                await chatController.addReaction(chatId, reaction, roomId);
              },
              handlePressedReactions: () async {
                await chatController.removeReaction(chatId, roomId);
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
                child:
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        imageUrl.startsWith("http")
                                            ? CachedNetworkImage(
                                              imageUrl: imageUrl,
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
                            ),
                            message == "" ? Container() : SizedBox(height: 10),
                            message == "" ? Container() : Text(message),
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
