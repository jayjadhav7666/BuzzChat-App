import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:get/get.dart';

class Welcomefooterbutton extends StatelessWidget {
  const Welcomefooterbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      // ignore: body_might_complete_normally_nullable
      onSubmit: () {
        Get.offAllNamed('/authPage');
      },
      sliderButtonIcon: SizedBox(
        width: 25,
        height: 25,
        child: SvgPicture.asset(AssetsImages.plugSVG, width: 25),
      ),
      text: WelcomePageString.slideToStart,
      textStyle: Theme.of(context).textTheme.labelLarge,
      submittedIcon: SvgPicture.asset(AssetsImages.connetSVG, width: 25),
      innerColor: Theme.of(context).colorScheme.tertiary,

      outerColor: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
    );
  }
}
