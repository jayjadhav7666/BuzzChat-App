import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/config/strings.dart';
import 'package:buzzchat/controller/authController.dart';
import 'package:buzzchat/controller/changethemeController.dart';
import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/controller/statusController.dart';
import 'package:buzzchat/data/get_server_key.dart';
import 'package:buzzchat/data/notification_services.dart';
import 'package:buzzchat/pages/auth/auth_page.dart';
import 'package:buzzchat/pages/callHistory/callhistory.dart';
import 'package:buzzchat/pages/group/group_page.dart';
import 'package:buzzchat/pages/group/new%20group/new_group.dart';
import 'package:buzzchat/pages/home/widget/chat_list.dart';
import 'package:buzzchat/pages/home/widget/tab_bar.dart';
import 'package:buzzchat/pages/search/search_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController; // Declare as late
  NotificationServices notificationServices = NotificationServices();
  GetServerKey getServerKey = GetServerKey();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    notificationServices.requestNotificationServices();
    notificationServices.firebaseInit(context);
    notificationServices.setUpInteractionMessage(context);
  
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(Profilecontroller());
    Get.put(Statuscontroller());
    Get.put(ContactController());
    // Get.put(GroupCallController());
    AuthController authController = Get.put(AuthController());
    // Get.put(Callcontroller());
    Changethemecontroller changethemecontroller = Get.put(
      Changethemecontroller(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.appName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(AssetsImages.appIconSVG),
        ),
        actions: [
          IconButton(
            onPressed: () async {
               Get.to(SearchChatPage());

              // await SendnotificationService.sendNotificationUsingApi(
              //   token:
              //       'd9sQn4PlRWKH6yq9tjAGRn:APA91bEkuOiuG96xfBdGDmr6sTql4bQAKpXMKzKMl6aG71ZTx5hPOzo6abFpQAeokj_THFBzOFlkxJ2qHRJpGaKoGvnGTUdDPl_B5MCculP1cCr1dFvCHgM',
              //   title: 'BuzzChat',
              //   body: 'Send message lets do chat',
              //   data: {'data': 'Tushar'},
              // );
            },
            icon: Icon(Icons.search, size: 27),
          ),
          PopupMenuButton<String>(
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
          ),
        ],
        bottom: myTabBar(tabController, context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/contactePage');
        },
        child: Center(child: Icon(Icons.add)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TabBarView(
          controller: tabController,
          children: [ChatList(), GroupPageScren(), CallHistoryPage()],
        ),
      ),
    );
  }
}
