import 'package:buzzchat/controller/profileController.dart';
import 'package:buzzchat/model/chatRoomModel.dart';
import 'package:buzzchat/model/groupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class SearchChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Profilecontroller profilecontroller = Get.put(Profilecontroller());
  // Fetch all user chat rooms
  Stream<List<ChatRoomModel>> getChatRooms() {
    return firestore.collection('chats').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatRoomModel.fromJson(doc.data()))
          .where(
            (chatRoom) =>
                chatRoom.sender!.id == profilecontroller.currentUser.value.id ||
                chatRoom.receiver!.id == profilecontroller.currentUser.value.id,
          )
          .toList();
    });
  }

  // Fetch all group chat rooms
  Stream<List<GroupModel>> getGroupChats() {
    return firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Merge all chat rooms & groups into one list
  Stream<List<dynamic>> getAllChatsAndGroups() {
    return CombineLatestStream.combine2(getChatRooms(), getGroupChats(), (
      List<ChatRoomModel> chatRooms,
      List<GroupModel> groupChats,
    ) {
      return [...chatRooms, ...groupChats].toList(); // Removing duplicates
    });
  }

  // Search within fetched chat rooms & groups
  Stream<List<dynamic>> searchAllChats(String query) {
    return getAllChatsAndGroups().map((allItems) {
      return allItems.where((item) {
        if (item is ChatRoomModel) {
          return item.receiver!.name!.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              item.sender!.name!.toLowerCase().contains(query.toLowerCase());
        } else if (item is GroupModel) {
          return item.name!.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    });
  }
}
