import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangodevelopment/ignore.dart';
import 'package:mangodevelopment/model/food.dart';

var serverToken = serverKey;

// send FCM when send message
void sendMessage(String token,String name, String message, String chatID) async{
  // print('$token $name $message!!');

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
        'status': 'done',
        'type': 'message',
        'chatID': chatID,
        'friendName': name
      },
      'to': token
    }),
  );

}

// send FCM in food shelf life
void sendFoodAlarm(String token, Food food, int date) async{
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': '${food.name} ${food.number}', 'title': '유통기한: ${food.shelfLife}으로부터 $date일 남았습니다'
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

void sendDeleteAlarm(){}

/*void sendFriendRequest(String token, String name) async {

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
*/