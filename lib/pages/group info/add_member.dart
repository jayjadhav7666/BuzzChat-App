import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/groupController.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/group%20info/group_detail.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMember extends StatefulWidget {
  final GroupModel groupModel;
  const AddMember({super.key, required this.groupModel});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<UserModel> members = [];

  @override
  void initState() {
    super.initState();
    fetchGroupMembers();
  }

  Future<void> fetchGroupMembers() async {
    DocumentSnapshot groupSnapshot =
        await firestore.collection("groups").doc(widget.groupModel.id).get();

    if (groupSnapshot.exists) {
      Map<String, dynamic> data = groupSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey("members")) {
        members =
            (data["members"] as List)
                .map((e) => UserModel.fromJson(e))
                .toList();
      }
    }
    setState(() {});
  }

  Stream<List<UserModel>> remainingMembers() {
    return firestore.collection('users').snapshots().map((snapshot) {
      List<UserModel> allUsers =
          snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
      List<UserModel> nonMembers =
          allUsers
              .where((user) => members.every((m) => m.id != user.id))
              .toList();

      return nonMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    Groupcontroller groupcontroller = Get.put(Groupcontroller());
    return Scaffold(
      appBar: AppBar(title: const Text('Add Members')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: remainingMembers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Remaining Contacts'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var user = snapshot.data![index];
                      return GestureDetector(
                        onTap: () async {
                          await groupcontroller
                              .addMemberToGroup(widget.groupModel.id!, user)
                              .then((value) {
                                successMessage('new member added in group ');
                                Get.off(
                                  GroupInfoPage(groupId: widget.groupModel.id!),
                                );
                              });
                        },
                        child: ChatTile(
                          imageUrl:
                              user.profileImage ?? AssetsImages.defaultIcons,
                          name: user.name ?? '',
                          lastChat: user.about ?? '',
                          lastTime: '',
                          unreadCount: 0,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
