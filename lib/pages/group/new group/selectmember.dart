import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupChatController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectMembers extends StatelessWidget {
  const SelectMembers({super.key});

  @override
  Widget build(BuildContext context) {
    Groupcontroller groupcontroller = Get.find<Groupcontroller>();
    return Obx(
      () => Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children:
            groupcontroller.groupMember.map((e) {
              return Stack(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: e.profileImage ?? AssetsImages.defaultIcons,
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
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        groupcontroller.groupMember.remove(e);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
