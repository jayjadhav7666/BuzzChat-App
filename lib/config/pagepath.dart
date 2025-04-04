import 'package:buzzchat/pages/auth/auth_page.dart';
import 'package:buzzchat/pages/contactPage/contact_page.dart';
import 'package:buzzchat/pages/home/home_screen.dart';
import 'package:buzzchat/pages/profile/profile_page.dart';
import 'package:buzzchat/pages/welcome/welcome.dart';
import 'package:get/get.dart';

var pagePath = [
  GetPage(
    name: '/authPage',
    page: () => AuthPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/welcomePage',
    page: () => WelcomeScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/homePage',
    page: () => HomeScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/profilePage',
    page: () => ProfilePage(),
    transition: Transition.rightToLeft,
  ),
  // GetPage(
  //   name: '/userProfilePage',
  //   page: () => UserProfilePage(),
  //   transition: Transition.rightToLeft,
  // ),
  GetPage(
    name: '/contactePage',
    page: () => ContactPage(),
    transition: Transition.rightToLeft,
  ),
  //   GetPage(
  //   name: '/updateprofilePage',
  //   page: () => UpdateProfile(),
  //   transition: Transition.rightToLeft,
  // ),
  // GetPage(
  //   name: '/chatPage',
  //   page: () => ChatPage(),
  //   transition: Transition.rightToLeft,
  // ),
];
