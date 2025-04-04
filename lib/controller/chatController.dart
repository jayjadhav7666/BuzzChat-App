import 'dart:developer';

import 'package:buzzchat/controller/contactController.dart';
import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/data/sendnotification_service.dart';
import 'package:buzzchat/model/callModel.dart';
import 'package:buzzchat/model/chatModel.dart';
import 'package:buzzchat/model/chatRoomModel.dart';
import 'package:buzzchat/model/groupcallModel.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class Chatcontroller extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Profilecontroller profilecontroller = Get.put(Profilecontroller());
  ContactController contactController = Get.put(ContactController());
  RxString selectedImagePath = ''.obs;
  RxBool isLoading = false.obs;
  var uuid = Uuid();

  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.uid;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUserId + targetUserId;
    } else {
      return targetUserId + currentUserId;
    }
  }

  UserModel getSender(UserModel currentUser, UserModel targetUser) {
    String currentUserId = currentUser.id!;
    String targetUserId = targetUser.id!;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUser;
    } else {
      return targetUser;
    }
  }

  UserModel getReciver(UserModel currentUser, UserModel targetUser) {
    String currentUserId = currentUser.id!;
    String targetUserId = targetUser.id!;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return targetUser;
    } else {
      return currentUser;
    }
  }

  Future<void> sendMessage(
    String targetUserId,
    String message,
    UserModel targetUser,
  ) async {
    isLoading.value = true;
    String roomId = getRoomId(targetUserId);
    String chatId = uuid.v6();
    DateTime timestamp = DateTime.now();

    String lastMessageTime = formatLastMessageTime(timestamp);

    RxString imageUrl = ''.obs;

    if (selectedImagePath.value.isNotEmpty) {
      imageUrl.value = await profilecontroller.uploadImageandDownloadUrl(
        selectedImagePath.value,
      );
    }

    UserModel sender = getSender(
      profilecontroller.currentUser.value,
      targetUser,
    );
    UserModel receiver = getReciver(
      profilecontroller.currentUser.value,
      targetUser,
    );
    var newChat = ChatModel(
      id: chatId,
      message: message,
      imageUrl: imageUrl.value,
      senderId: auth.currentUser!.uid,
      receiverId: targetUserId,
      senderName: profilecontroller.currentUser.value.name,
      timestamp: DateTime.now().toString(),
      readStatus: "unread",
    );

    var roomDetails = ChatRoomModel(
      id: roomId,
      lastMessage: message,
      lastMessageTimestamp: lastMessageTime,
      sender: sender,
      receiver: receiver,
      timestamp: DateTime.now().toString(),
      unReadMessNo: 0,
    );
    try {
      await firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .doc(chatId)
          .set(newChat.toJson());
      await firestore.collection('chats').doc(roomId).set(roomDetails.toJson());

      await contactController.saveContact(targetUser);

      await SendnotificationService.sendNotificationUsingApi(
        token: targetUser.userDeviceToken,
        title: profilecontroller.currentUser.value.name,
        body: message,
        data: {
          'type': 'chat',
          'senderId': auth.currentUser!.uid,
          'senderName': profilecontroller.currentUser.value.name,
          'chatId': chatId,
          'roomId': roomId,
          'image': imageUrl.value,
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
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

  Stream<List<ChatModel>> getMessage(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return firestore
        .collection('chats')
        .doc(roomId)
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

  Future<void> editMessage(String chatId, String roomId, String message) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc(chatId)
        .update({'message': message});
  }

  Future<void> deleteMessage(String chatId, String roomId) async {
    final messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
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
      print("Message deleted successfully");
    } else {
      print("Message does not exist!");
    }
  }

  Future<void> addReaction(
    String chatId,
    String reaction,
    String roomId,
  ) async {
    try {
      await firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .doc(chatId)
          .update({
            'reactions': [reaction],
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<ChatModel> getReaction(String chatId, String roomId) {
    return firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc(chatId)
        .snapshots()
        .map((event) {
          if (event.exists && event.data() != null) {
            return ChatModel.fromJson(event.data()!);
          }
          return ChatModel(reactions: []); // Ensure non-null default
        });
  }

  Future<void> removeReaction(String chatId, String roomId) async {
    try {
      await firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .doc(chatId)
          .update({'reactions': []}); // Remove the reaction
    } catch (e) {
      print("Error removing reaction: $e");
    }
  }

  Stream<UserModel> getStatus(String targetUserId) {
    return firestore.collection('users').doc(targetUserId).snapshots().map((
      event,
    ) {
      return UserModel.fromJson(event.data()!);
    });
  }

  Stream<int> getUnreadMessageCount(String roomId) {
    String? currentUserId = profilecontroller.currentUser.value.id;

    if (currentUserId == null) {
      return Stream.value(0);
    }

    return firestore
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .snapshots()
        .map((snapshot) {
          // Filtering messages in Dart
          int unreadCount =
              snapshot.docs.where((doc) {
                var data = doc.data();
                return data["readStatus"] == "unread" &&
                    data["senderId"] != currentUserId;
              }).length;
          return unreadCount;
        });
  }

  Future<void> markMessagesAsRead(String roomId) async {
    QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await firestore
            .collection("chats")
            .doc(roomId)
            .collection("messages")
            .where("readStatus", isEqualTo: "unread")
            .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> messageDoc
        in messagesSnapshot.docs) {
      String senderId = messageDoc.data()["senderId"];
      if (senderId != profilecontroller.currentUser.value.id) {
        await firestore
            .collection("chats")
            .doc(roomId)
            .collection("messages")
            .doc(messageDoc.id)
            .update({"readStatus": "read"});
      }
    }
  }

  Stream<List<dynamic>> getMergedCalls() {
    // Fetch individual calls as CallModel
    Stream<List<dynamic>> individualCalls = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("calls")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CallModel.fromJson(doc.data()))
                  .toList(),
        );

    // Fetch group calls as GroupCallModel
    Stream<List<dynamic>> groupCalls = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("groupCalls")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => GroupCallModel.fromJson(doc.data()))
                  .toList(),
        );

    // Merge both streams into List<dynamic>
    return CombineLatestStream.combine2(individualCalls, groupCalls, (
      List<dynamic> ind,
      List<dynamic> grp,
    ) {
      List<dynamic> mergedCalls = [...ind, ...grp];

      // Sort dynamically by timestamp (assuming timestamp exists in both models)
      mergedCalls.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

      return mergedCalls;
    });
  }
}
