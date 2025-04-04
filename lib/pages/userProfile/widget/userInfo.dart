import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/callController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/callPage/audioCallPage.dart';
import 'package:buzzchat/pages/callPage/videoCallPage.dart';
import 'package:buzzchat/widget/details_dp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserInfo extends StatelessWidget {
  final UserModel userModel;
  const UserInfo({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    Callcontroller callcontroller = Get.put(Callcontroller());
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onLongPress: () {
                    detailDp(
                      context,
                      userModel.profileImage,
                      AssetsImages.defaultIcons,
                    );
                  },
                  child: Container(
                    height: 110,
                    width: 110,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                      imageUrl:
                          userModel.profileImage ?? AssetsImages.defaultIcons,
                      fit: BoxFit.cover,

                      placeholder:
                          (context, url) => Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userModel.name!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  userModel.email!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await callcontroller.callAction(
                          userModel,
                          profilecontroller.currentUser.value,
                          'audio',
                        );
                        Get.to(Audiocallpage(target: userModel));
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
                        await callcontroller.callAction(
                          userModel,
                          profilecontroller.currentUser.value,
                          'video',
                        );
                        Get.to(Videocallpage(target: userModel));
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
                        Get.back();
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
                              AssetsImages.appIconSVG,
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Chat",
                              style: TextStyle(color: Color(0xff0057FF)),
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
    );
  }
}
