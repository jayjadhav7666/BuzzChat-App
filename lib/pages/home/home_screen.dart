import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/config/strings.dart';
import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/controller/statusController.dart';
import 'package:buzzchat/data/notification_services.dart';
import 'package:buzzchat/pages/callHistory/callhistory.dart';
import 'package:buzzchat/pages/group/group_page.dart';
import 'package:buzzchat/pages/home/widget/chat_list.dart';
import 'package:buzzchat/pages/home/widget/popupmenu_button.dart';
import 'package:buzzchat/pages/home/widget/tab_bar.dart';
import 'package:buzzchat/pages/search/search_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    notificationServices.requestNotificationServices();
    notificationServices.firebaseInit(context);
    notificationServices.setUpInteractionMessage(context);
    notificationServices.refreshFcmTokenListener(auth.currentUser!.uid);
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
    // Get.put(Callcontroller());

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
          //for search button
          IconButton(
            onPressed: () async {
              Get.to(SearchChatPage());
            },
            icon: Icon(Icons.search, size: 27),
          ),
          //for pop up button
          PopupmenuButtonClick(),
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
