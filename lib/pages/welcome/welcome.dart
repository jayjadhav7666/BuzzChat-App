import 'package:buzzchat/pages/welcome/widgets/welcome_Footer_Button.dart';
import 'package:buzzchat/pages/welcome/widgets/welcome_body.dart';
import 'package:buzzchat/pages/welcome/widgets/welcome_heading.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WelcomeHeading(),
              const SizedBox(height: 60),
              WelcomeBody(),
              const SizedBox(height: 90),
              Welcomefooterbutton(),
            ],
          ),
        ),
      ),
    );
  }
}
