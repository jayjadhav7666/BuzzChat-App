import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupCallController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/group%20info/add_member.dart';
import 'package:buzzchat/pages/group%20info/edit_details.dart';
import 'package:buzzchat/pages/groupcallPage/videoCallPage.dart';
import 'package:buzzchat/widget/details_dp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GroupInfo extends StatelessWidget {
  final GroupModel groupModel;
  const GroupInfo({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    GroupCallController groupCallController = Get.put(GroupCallController());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        detailDp(
                          context,
                          groupModel.profileUrl,
                          AssetsImages.defaultgroupIcons,
                        );
                      },
                      child: Container(
                        height: 110,
                        width: 110,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: CachedNetworkImage(
                          imageUrl:
                              groupModel.profileUrl ??
                              AssetsImages.defaultgroupIcons,
                          fit: BoxFit.cover,

                          placeholder:
                              (context, url) => Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      groupModel.name!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      groupModel.description ?? 'No Description Available',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            List<UserModel> participants =
                                groupModel.members!
                                    .where(
                                      (member) =>
                                          member.id !=
                                          profilecontroller
                                              .currentUser
                                              .value
                                              .id,
                                    )
                                    .toList();
                            await groupCallController.initiateGroupCall(
                              participants,
                              profilecontroller.currentUser.value,
                              'video',
                              groupModel,
                            );
                            Get.to(GroupVideoCallPage(id: groupModel.id!));
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsImages.profileAudioCall,
                                  width: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Call",
                                  style: TextStyle(color: Color(0xff039C00)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Create a new list excluding the caller
                            List<UserModel> participants =
                                groupModel.members!
                                    .where(
                                      (member) =>
                                          member.id !=
                                          profilecontroller
                                              .currentUser
                                              .value
                                              .id,
                                    )
                                    .toList();
                            await groupCallController.initiateGroupCall(
                              participants,
                              profilecontroller.currentUser.value,
                              'video',
                              groupModel,
                            );
                            Get.to(GroupVideoCallPage(id: groupModel.id!));
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsImages.profileVideoCall,
                                  width: 25,
                                  colorFilter: ColorFilter.mode(
                                    Color(0xffFF9900),
                                    BlendMode
                                        .srcIn, // Ensures proper color application
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Video",
                                  style: TextStyle(color: Color(0xffFF9900)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            bool isAdmin = groupModel.members!.any(
                              (e) =>
                                  e.id == auth.currentUser!.uid &&
                                  e.role == 'admin',
                            );
                            if (isAdmin) {
                              Get.to(AddMember(groupModel: groupModel));
                            } else {
                              warningMessage(
                                'Only admin have permission to add new members.',
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsImages.groupAddUser,
                                  width: 25,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Add",
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () {
                showUpdateGroupDialog(context, groupModel);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
