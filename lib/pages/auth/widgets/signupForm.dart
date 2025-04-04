import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/controller/authController.dart';
import 'package:buzzchat/pages/auth/widgets/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    AuthController authController = Get.put(AuthController());
    return Column(
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: email,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: password,
          obscureText: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.password_outlined),
          ),
        ),
        const SizedBox(height: 40),
        Obx(
          () =>
              authController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Primarybutton(
                        name: 'SignUp',
                        icon: Icons.lock_open_outlined,
                        onTap: () async {
                          if (name.text.isEmpty ||
                              email.text.isEmpty ||
                              password.text.isEmpty) {
                            warningMessage('Please fill details.');
                            return;
                          } else {
                            await authController.createUser(
                              name.text.trim(),
                              email.text.trim(),
                              password.text.trim(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
