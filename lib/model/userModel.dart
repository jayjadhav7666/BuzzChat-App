class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? phoneNumber;
  String? about;
  String? createdAt;
  String? status;
  String? role;
  String? userDeviceToken;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.phoneNumber,
    this.about,
    this.createdAt,
    this.status,
    this.role,
    this.userDeviceToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    profileImage = json["profileImage"];
    phoneNumber = json["phoneNumber"];
    about = json["about"];
    createdAt = json["createdAt"];
    status = json["status"];
    role = json["role"];
    userDeviceToken = json["userDeviceToken"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["profileImage"] = profileImage;
    data["phoneNumber"] = phoneNumber;
    data["about"] = about;
    data["createdAt"] = createdAt;
    data["status"] = status;
    data["role"] = role;
    data["userDeviceToken"] = userDeviceToken; // 🔥 Serialize
    return data;
  }
}
