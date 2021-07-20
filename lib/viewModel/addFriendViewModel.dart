import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var serverToken =
    'AAAAA2rmKow:APA91bE0C2NC74vPLJfyyUrwBKsodxH--X4G30WqduS_DN0uAYM8J4c9k0FWNkSSd6aG8TUsZzihoFv-8cy75ydfaR-XeHPKoOIMFjlgkp1yLgXv-X0qpruo5-6uPRPsdnPf1CjdKkWR';

void sendFriendRequest(String token) async {
  // List<String> friendTokens = tokens.map((s) => s as String).toList();
  // print('tokens' + friendTokens[0].toString());

  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{'body': '이인석 바보', 'title': '친구 요청'},
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
