import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/controller/authController.dart';
import 'package:buzzchat/pages/auth/forgot_password.dart';
import 'package:buzzchat/pages/auth/widgets/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    AuthController authController = Get.put(AuthController());

    return Column(
      children: [
        const SizedBox(height: 40),
        TextFormField(
          controller: email,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: password,
          textInputAction: TextInputAction.next,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.password_outlined),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(ForgotPassword());
              },
              child: Text(
                "Forgot Password ? ",
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 50),
        Obx(
          () =>
              authController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Primarybutton(
                        name: 'Login',
                        icon: Icons.lock_open_outlined,
                        onTap: () {
                          if (email.text.trim().isEmpty ||
                              password.text.trim().isEmpty) {
                            warningMessage('Please fill details.');
                            return;
                          } else {
                            authController.logIn(
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
