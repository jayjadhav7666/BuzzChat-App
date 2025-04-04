class GroupCallModel {
  String? id;
  String? groupName;
  String? groupPic; // Added group picture field
  String? callerName;
  String? callerPic;
  String? callerUid;
  String? callerEmail;
  List<Map<String, String>>?
  participants; // List of receiver details (name, email, pic, etc.)
  List<String>? participantUids; // Only UIDs for quick access
  String? status; // received, missed, ongoing
  String? type; // voice or video
  String? time;
  String? timestamp;

  GroupCallModel({
    this.id,
    this.groupName,
    this.groupPic, // Initialize groupPic
    this.callerName,
    this.callerPic,
    this.callerUid,
    this.callerEmail,
    this.participants,
    this.participantUids,
    this.status,
    this.type,
    this.time,
    this.timestamp,
  });

  GroupCallModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    groupName = json["groupName"];
    groupPic = json["groupPic"]; // Parse groupPic from JSON
    callerName = json["callerName"];
    callerPic = json["callerPic"];
    callerUid = json["callerUid"];
    callerEmail = json["callerEmail"];
    participants =
        (json["participants"] as List?)
            ?.map((e) => Map<String, String>.from(e))
            .toList();
    participantUids =
        (json["participantUids"] as List?)?.map((e) => e as String).toList();
    status = json["status"];
    type = json["type"];
    time = json["time"];
    timestamp = json["timestamp"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "groupName": groupName,
      "groupPic": groupPic, // Include groupPic in JSON
      "callerName": callerName,
      "callerPic": callerPic,
      "callerUid": callerUid,
      "callerEmail": callerEmail,
      "participants": participants,
      "participantUids": participantUids,
      "status": status,
      "type": type,
      "time": time,
      "timestamp": timestamp,
    };
  }
}
