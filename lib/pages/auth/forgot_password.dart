import 'package:buzzchat/controller/authController.dart';
import 'package:buzzchat/pages/auth/widgets/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your email id and we will send you reset password link on email",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: "Enter Email id",
                fillColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () =>
                  authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : Primarybutton(
                        name: "Reset Now",
                        icon: Icons.password_outlined,
                        onTap: () {
                          authController.resetPassword(email.text);
                          Get.back();
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
