import 'dart:convert';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/data/get_server_key.dart';
import 'package:http/http.dart' as http;

class SendnotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();

    String url =
        "https://fcm.googleapis.com/v1/projects/buzzchat-chat-app/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    //message
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
        "data": data,
      },
    };

    //hit api
    http.Response reresponse = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (reresponse.statusCode == 200) {
      // log('message send successfully');
    } else {
      // log('message not send');
      errorMessage('${reresponse.statusCode}');
    }
  }
}
