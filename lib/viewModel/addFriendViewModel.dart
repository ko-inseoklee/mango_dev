import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangodevelopment/ignore.dart';

var serverToken = serverKey;

void sendMessage(String token,String name, String message) async{
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': '$message', 'title': '$name 님으로 부터 새로운 메시지가 도착했습니다.'
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': token
    }),
  );

}
void sendFriendRequest(String token, String name) async {

  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{'body': '$name님이 친구가 되길 원합니다.', 'title': '친구 요청'},
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': token
    }),
  );
}
