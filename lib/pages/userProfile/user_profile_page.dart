import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/userProfile/widget/userInfo.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final UserModel userModel;
  const UserProfilePage({super.key, required this.userModel});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back', style: Theme.of(context).textTheme.labelLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            UserInfo(userModel: widget.userModel,),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        SizedBox(height: 15),
                        Text(
                          widget.userModel.about ??
                              'Hey, there I am Using BuzzChat',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}
