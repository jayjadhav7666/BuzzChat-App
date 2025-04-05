class NotificationModel {
  final String? id;
  final String? senderId;
  final String? senderName;
  final String? message;
  final String? roomId;   // for private chat
  final String? chatId;   // for private chat
  final String? groupId;  // for group chat
  final String? timestamp;
  final String? imageUrl;
  final String? type;     // "chat" or "group"

  NotificationModel({
    this.id,
    this.senderId,
    this.senderName,
    this.message,
    this.roomId,
    this.chatId,
    this.groupId,
    this.timestamp,
    this.imageUrl,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "senderName": senderName,
        "message": message,
        "roomId": roomId,
        "chatId": chatId,
        "groupId": groupId,
        "timestamp": timestamp,
        "imageUrl": imageUrl,
        "type": type,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        senderId: json["senderId"],
        senderName: json["senderName"],
        message: json["message"],
        roomId: json["roomId"],
        chatId: json["chatId"],
        groupId: json["groupId"],
        timestamp: json["timestamp"],
        imageUrl: json["imageUrl"],
        type: json["type"],
      );
}
