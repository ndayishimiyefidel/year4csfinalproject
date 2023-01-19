import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> sendPushNotification(
    String name, String userToken, String body, String image) async {
  print("SENDING PUSH NOTIFICATION");
  const String FCM_SERVER_KEY =
      "AAAAubvHZpA:APA91bF3XJg-S0E6Q0EezKLEFcuoRlDNpeSyxcqW437fXbFoPc0EWgNg0y9Gb5BVNqa_PxBkoVoXQqlZ4nRFBFurrbyquyUvHJPPQhj1AM9MDBGNwH5qo5aDs6kJt1sSFqcMDgV4oBSi";
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "notification": {"body": body, "title": name, "image": image},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done"
    },
    "to": userToken
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': "key=$FCM_SERVER_KEY" // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: jsonEncode(data),
      // encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    // print('test ok push CFM');
    return true;
  } else {
    // print(' CFM error');
    // on failure do sth
    return false;
  }
}
