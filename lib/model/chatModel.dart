class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? timestamp;
  String? readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;
  List<String>? readBy; // New field to track which users have read the message

  ChatModel({
    this.id,
    this.message,
    this.senderName,
    this.senderId,
    this.receiverId,
    this.timestamp,
    this.readStatus,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    this.reactions,
    this.replies,
    this.readBy,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["senderName"] is String) {
      senderName = json["senderName"];
    }
    if (json["senderId"] is String) {
      senderId = json["senderId"];
    }
    if (json["receiverId"] is String) {
      receiverId = json["receiverId"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
    if (json["readStatus"] is String) {
      readStatus = json["readStatus"];
    }
    if (json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if (json["videoUrl"] is String) {
      videoUrl = json["videoUrl"];
    }
    if (json["audioUrl"] is String) {
      audioUrl = json["audioUrl"];
    }
    if (json["documentUrl"] is String) {
      documentUrl = json["documentUrl"];
    }
    if (json["reactions"] is List) {
      reactions = json["reactions"] == null
          ? null
          : List<String>.from(json["reactions"]);
    }
    if (json["replies"] is List) {
      replies = json["replies"] ?? [];
    }
    if (json["readBy"] is List) {
      readBy = json["readBy"] == null ? [] : List<String>.from(json["readBy"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["message"] = message;
    data["senderName"] = senderName;
    data["senderId"] = senderId;
    data["receiverId"] = receiverId;
    data["timestamp"] = timestamp;
    data["readStatus"] = readStatus;
    data["imageUrl"] = imageUrl;
    data["videoUrl"] = videoUrl;
    data["audioUrl"] = audioUrl;
    data["documentUrl"] = documentUrl;
    if (reactions != null) {
      data["reactions"] = reactions;
    }
    if (replies != null) {
      data["replies"] = replies;
    }
    data["readBy"] = readBy ?? []; // Save an empty list if null
    return data;
  }

  /// Instance method to mark this message as read by a given user.
  void markAsRead(String userId) {
    readStatus = "read";
    if (readBy == null) {
      readBy = [];
    }
    if (!readBy!.contains(userId)) {
      readBy!.add(userId);
    }
  }
}
