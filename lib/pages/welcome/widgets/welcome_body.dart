import 'package:buzzchat/config/colors.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsImages.boyPic),
            SvgPicture.asset(AssetsImages.connetSVG),
            Image.asset(AssetsImages.girlPic),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          WelcomePageString.nowYourAre,
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        Text(
          WelcomePageString.connected,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(color: dtertiaryColor),
        ),
        const SizedBox(height: 20),
        Text(
          WelcomePageString.discription,
          textAlign: TextAlign.center,
          style:
              Theme.of(context).brightness == Brightness.light
                  ? Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: lOnBackgroundColor)
                  : Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
