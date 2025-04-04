import 'package:buzzchat/config/colors.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SvgPicture.asset(AssetsImages.appIconSVG)],
        ),
        const SizedBox(height: 10),
        Text(
          AppString.appName,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(color: dtertiaryColor),
        ),
      ],
    );
  }
}
