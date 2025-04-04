import 'package:buzzchat/pages/auth/widgets/loginForm.dart';
import 'package:buzzchat/pages/auth/widgets/signupForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isLogin = true.obs;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          isLogin.value = true;
                        },
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              style:
                                  isLogin.value
                                      ? Theme.of(context).textTheme.bodyLarge
                                      : Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              height: 3,
                              width: isLogin.value ? 100 : 0,
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          isLogin.value = false;
                        },
                        child: Column(
                          children: [
                            Text(
                              'Signup',
                              style:
                                  isLogin.value
                                      ? Theme.of(context).textTheme.labelLarge
                                      : Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              height: 3,
                              width: isLogin.value ? 0 : 100,
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => isLogin.value ? LoginForm() : SignUpForm()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
