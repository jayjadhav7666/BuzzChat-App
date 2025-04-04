import 'dart:developer';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/config/images.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/chatModel.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Groupcontroller extends GetxController {
  RxList<UserModel> groupMember = <UserModel>[].obs;
  RxList<GroupModel> gropuList = <GroupModel>[].obs;
  Profilecontroller profilecontroller = Get.put(Profilecontroller());
  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString selectedImagePath = "".obs;
  var uuid = Uuid();
  @override
  void onInit() {
    super.onInit();
    getGroups();
  }

  void selectMember(UserModel user) {
    if (groupMember.any((member) => member.id == user.id)) {
      groupMember.removeWhere((member) => member.id == user.id);
    } else {
      groupMember.add(user);
    }
  }

  Future<void> createGroup(
    String groupName,
    String imagePath, {
    String description = '',
  }) async {
    isLoading.value = true;
    String groupId = Uuid().v6();
    String imageUrl = '';

    groupMember.add(
      UserModel(
        id: auth.currentUser!.uid,
        name: profilecontroller.currentUser.value.name,
        profileImage:
            profilecontroller.currentUser.value.profileImage ??
            AssetsImages.defaultIcons,
        phoneNumber: profilecontroller.currentUser.value.phoneNumber,
        status: profilecontroller.currentUser.value.status,
        email: profilecontroller.currentUser.value.email,
        about: profilecontroller.currentUser.value.name,
        createdAt: profilecontroller.currentUser.value.createdAt,
        role: 'admin',
      ),
    );
    try {
      if (imagePath.isNotEmpty) {
        imageUrl = await profilecontroller.uploadImageandDownloadUrl(imagePath);
      } else {
        imageUrl = AssetsImages.defaultgroupIcons;
      }

      await firestore.collection('groups').doc(groupId).set({
        'id': groupId,
        'name': groupName,
        'profileUrl': imageUrl,
        'members': groupMember.map((e) => e.toJson()).toList(),
        'createdAt': DateTime.now().toString(),
        'createdBy': auth.currentUser!.uid,
        'timeStamp': DateTime.now().toString(),
        'escription': description,
      });
      successMessage('Group Created Successfully');
      Get.offAllNamed('/homePage');
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = true;
    }
  }

  Future<void> getGroups() async {
    isLoading.value = true;
    List<GroupModel> tempGroup = [];
    await firestore
        .collection('groups')
        .get()
        .then(
          (value) =>
              tempGroup =
                  value.docs.map((e) => GroupModel.fromJson(e.data())).toList(),
        );
    gropuList.clear();
    gropuList.value =
        tempGroup
            .where(
              (gp) => gp.members!.any(
                (person) => person.id == auth.currentUser!.uid,
              ),
            )
            .toList();
  }

  Stream<List<GroupModel>> getGroupss() {
    isLoading.value = true;
    return firestore
        .collection('groups')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
          List<GroupModel> tempGroup =
              snapshot.docs.map((e) => GroupModel.fromJson(e.data())).toList();

          gropuList.clear();
          gropuList.value =
              tempGroup
                  .where(
                    (gp) => gp.members!.any(
                      (person) => person.id == auth.currentUser!.uid,
                    ),
                  )
                  .toList();

          isLoading.value = false;
          return gropuList;
        });
  }

  Future<void> sendGroupMessage(
    String groupId,
    String message,
    GroupModel groupModel,
  ) async {
    isLoading.value = true;
    var chatId = uuid.v6();
    String imageUrl = await profilecontroller.uploadImageandDownloadUrl(
      selectedImagePath.value,
    );
    DateTime timestamp = DateTime.now();

    String lastMessageTime = formatLastMessageTime(timestamp);

    var newChat = ChatModel(
      id: chatId,
      message: message,
      imageUrl: imageUrl,
      senderId: auth.currentUser!.uid,
      senderName: profilecontroller.currentUser.value.name,
      timestamp: DateTime.now().toString(),
      readStatus: "unread",
    );

    await firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(chatId)
        .set(newChat.toJson());
    await firestore.collection('groups').doc(groupId).update({
      'lastMessage': message,
      'lastMessageBy': profilecontroller.currentUser.value.id,
      'lastMessageTime': lastMessageTime,
    });
    selectedImagePath.value = "";
    isLoading.value = false;
  }

  Stream<List<ChatModel>> getGroupMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  Future<void> editGroupMessage(
    String chatId,
    String groupId,
    String message,
  ) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(chatId)
        .update({'message': message});
  }

  Future<void> deleteGroupMessage(String chatId, String groupId) async {
    final messageRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(chatId);

    final messageSnapshot = await messageRef.get();

    if (messageSnapshot.exists) {
      final messageData = messageSnapshot.data();

      if (messageData != null && messageData.containsKey('imageUrl')) {
        String imageUrl = messageData['imageUrl'];

        if (imageUrl.isNotEmpty) {
          try {
            Reference storageRef = FirebaseStorage.instance.refFromURL(
              imageUrl,
            );
            await storageRef.delete();
          } catch (e) {
            log(e.toString());
          }
        }
      }

      // Delete the message from Firestore
      await messageRef.delete();
    }
  }

  String formatLastMessageTime(DateTime timestamp) {
    DateTime now = DateTime.now();
    String time = DateFormat('hh:mm a').format(timestamp); // e.g., 10:20 PM
    String date = DateFormat(
      'dd/MM/yyyy',
    ).format(timestamp); // e.g., 29/03/2025

    if (timestamp.day == now.day &&
        timestamp.month == now.month &&
        timestamp.year == now.year) {
      return time; // Today → Only time
    } else if (timestamp.day == now.subtract(Duration(days: 1)).day &&
        timestamp.month == now.month &&
        timestamp.year == now.year) {
      return 'Yesterday'; // Yesterday → Only "Yesterday"
    } else {
      return date; // Older messages → Only date
    }
  }

  Future<void> addReaction(
    String chatId,
    String reaction,
    String groupId,
  ) async {
    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(chatId)
          .update({
            'reactions': [reaction],
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<ChatModel> getGroupMessageReaction(String chatId, String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(chatId)
        .snapshots()
        .map((event) {
          return ChatModel.fromJson(event.data()!);
        });
  }

  Future<void> removeGroupMessageReaction(String chatId, String groupId) async {
    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(chatId)
          .update({'reactions': []});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addMemberToGroup(String groupId, UserModel user) async {
    isLoading.value = true;
    await firestore.collection("groups").doc(groupId).update({
      "members": FieldValue.arrayUnion([user.toJson()]),
    });
    getGroupss();
    isLoading.value = false;
  }

  Future<void> updateGroup(
    String groupId,
    String groupname,
    String image,
    String description,
  ) async {
    String imageUrl = image; // Default to given image

    // Check if image is a local file (not a URL)
    if (!image.startsWith("http")) {
      imageUrl = await profilecontroller.uploadImageandDownloadUrl(image);
    }

    await firestore.collection('groups').doc(groupId).update({
      'name': groupname,
      'description': description,
      'profileUrl': imageUrl,
    });
  }

  Future<void> markGroupMessagesAsRead(String groupId) async {
    // Get the total number of group members from the group document.
    DocumentSnapshot groupDoc =
        await firestore.collection("groups").doc(groupId).get();
    final groupData = groupDoc.data() as Map<String, dynamic>?;
    List<dynamic> groupMembers = groupData?["members"] ?? [];
    int totalMembers = groupMembers.length;

    // Query for messages in the group where the readStatus is "unread".
    QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await firestore
            .collection("groups")
            .doc(groupId)
            .collection("messages")
            .where("readStatus", isEqualTo: "unread")
            .get();

    // Loop through each unread message.
    for (QueryDocumentSnapshot<Map<String, dynamic>> messageDoc
        in messagesSnapshot.docs) {
      String senderId = messageDoc.data()["senderId"];
      // Only update if the message was not sent by the current user.
      if (senderId != profilecontroller.currentUser.value.id) {
        // First, add the current user's ID to the readBy array.
        await firestore
            .collection("groups")
            .doc(groupId)
            .collection("messages")
            .doc(messageDoc.id)
            .update({
              "readBy": FieldValue.arrayUnion([
                profilecontroller.currentUser.value.id,
              ]),
            });

        // Retrieve the updated message to check the readBy array length.
        DocumentSnapshot updatedMessageDoc =
            await firestore
                .collection("groups")
                .doc(groupId)
                .collection("messages")
                .doc(messageDoc.id)
                .get();
        final updatedMessageData =
            updatedMessageDoc.data() as Map<String, dynamic>?;
        List<dynamic> readByList = updatedMessageData?["readBy"] ?? [];
        int readCount = readByList.length;

        // Determine the new status based on whether all group members have read the message.
        String newStatus =
            (readCount == totalMembers - 1 && totalMembers > 0)
                ? "read"
                : "unread";

        // Update the message with the new status and readCount.
        await firestore
            .collection("groups")
            .doc(groupId)
            .collection("messages")
            .doc(messageDoc.id)
            .update({"readStatus": newStatus, "readCount": readCount});
      }
    }
  }

  Stream<int> getGroupUnreadMessageCount(String groupId) {
  String? currentUserId = profilecontroller.currentUser.value.id;
  
  if (currentUserId == null) {
    return Stream.value(0);
  }

  return firestore
      .collection("groups")
      .doc(groupId)
      .collection("messages")
      .snapshots()
      .map((snapshot) {
        int unreadCount = snapshot.docs.where((doc) {
          var data = doc.data();
          
          return data["senderId"] != currentUserId && // Don't count own messages
              !(data["readBy"] ?? []).contains(currentUserId); // Not read by user
        }).length;

        return unreadCount;
      });
}

}
