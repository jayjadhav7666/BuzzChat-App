import 'package:buzzchat/config/pagepath.dart';
import 'package:buzzchat/config/themes.dart';
import 'package:buzzchat/controller/changethemeController.dart';
import 'package:buzzchat/firebase_options.dart';
import 'package:buzzchat/pages/splashscreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Changethemecontroller changethemecontroller = Get.put(
      Changethemecontroller(),
    );
    return Obx(
      () => GetMaterialApp(
        builder: FToastBuilder(),
        title: 'BuzzChat',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode:
            changethemecontroller.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        getPages: pagePath,
        home: const SplashScreen(),
      ),
    );
  }
}
