import 'package:buzzchat/controller/authController.dart';
import 'package:buzzchat/controller/changethemeController.dart';
import 'package:buzzchat/pages/auth/auth_page.dart';
import 'package:buzzchat/pages/group/new%20group/new_group.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupmenuButtonClick extends StatelessWidget {
  const PopupmenuButtonClick({super.key});

  @override
  Widget build(BuildContext context) { // Get.put(GroupCallController());
    AuthController authController = Get.put(AuthController());
    // Get.put(Callcontroller());
    Changethemecontroller changethemecontroller = Get.put(
      Changethemecontroller(),
    );
    return PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new_group') {
                Get.to(NewGroup());
              } else if (value == 'profile') {
                Get.toNamed('/profilePage');
              } else if (value == 'change_theme') {
                changethemecontroller.toggleTheme();
              } else if (value == 'logout') {
                authController.logOut().then((value) {
                  Get.offAll(AuthPage());
                });
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'new_group',
                    child: Text(
                      'New Group',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'profile',
                    child: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'change_theme',
                    child: Text(
                      'Change Theme',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
            icon: Icon(Icons.more_vert_rounded, size: 27),
          );
  }
}