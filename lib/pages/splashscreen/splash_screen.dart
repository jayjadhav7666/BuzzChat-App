import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/splashController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
     Get.put(SplashController());
    return Scaffold(
      body: Center(child: SvgPicture.asset(AssetsImages.appIconSVG)),
    );
  }
}
