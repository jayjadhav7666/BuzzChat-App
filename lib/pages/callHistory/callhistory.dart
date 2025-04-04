import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/chatController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/callModel.dart';
import 'package:buzzchat/model/groupcallModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Chatcontroller chatcontroller = Get.put(Chatcontroller());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    return StreamBuilder(
      stream: chatcontroller.getMergedCalls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No call history available"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var call = snapshot.data![index];

            // Check if the call is an individual call or group call
            bool isGroupCall = call is GroupCallModel;

            String displayName =
                isGroupCall
                    ? call.groupName ?? "Unknown Group"
                    : call.callerUid == profilecontroller.currentUser.value.id
                    ? call.receiverName!
                    : call.callerName!;
            String displayPic =
                isGroupCall
                    ? call.groupPic ?? AssetsImages.defaultgroupIcons
                    : call.callerUid == profilecontroller.currentUser.value.id
                    ? call.receiverPic == null
                        ? AssetsImages.defaultIcons
                        : call.receiverPic!
                    : call.callerPic == null
                    ? AssetsImages.defaultIcons
                    : call.callerPic!;
            String formattedTime = DateFormat(
              'hh:mm a',
            ).format(DateTime.parse(call.timestamp!));

            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      imageUrl: displayPic,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                        ),
                        SizedBox(height: 7),
                        Text(
                          formattedTime,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          call.type == "video" ? Icons.video_call : Icons.call,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onPressed: () {},
                      ),
                      Icon(
                        call is CallModel &&
                                call.callerUid ==
                                    profilecontroller.currentUser.value.id
                            ? Icons.call_made
                            : Icons.call_received,
                        color:
                            call is CallModel &&
                                    call.callerUid ==
                                        profilecontroller.currentUser.value.id
                                ? Colors.green
                                : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
