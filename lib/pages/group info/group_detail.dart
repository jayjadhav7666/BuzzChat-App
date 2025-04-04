import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/pages/group%20info/groupInfo.dart';
import 'package:buzzchat/pages/home/widget/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final GroupModel? groupModel;
  final String groupId;
  const GroupInfoPage({super.key, required this.groupId, this.groupModel});

  @override
  State createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  GroupModel? groupModel;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    DocumentSnapshot groupSnapshot =
        await firestore.collection("groups").doc(widget.groupId).get();

    if (groupSnapshot.exists) {
      setState(() {
        groupModel = GroupModel.fromJson(
          groupSnapshot.data() as Map<String, dynamic>,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (groupModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(groupModel!.name!),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            GroupInfo(groupModel: groupModel!),
            const SizedBox(height: 20),
            Text("Members", style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 10),
            Column(
              children:
                  groupModel!.members!
                      .map(
                        (member) => ChatTile(
                          imageUrl:
                              member.profileImage ?? AssetsImages.defaultIcons,
                          name: member.name!,
                          lastChat: member.email!,
                          lastTime: member.role == 'admin' ? 'Admin' : 'User',
                          unreadCount: 0,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
