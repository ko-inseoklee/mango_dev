import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var serverToken =
    'AAAAA2rmKow:APA91bE0C2NC74vPLJfyyUrwBKsodxH--X4G30WqduS_DN0uAYM8J4c9k0FWNkSSd6aG8TUsZzihoFv-8cy75ydfaR-XeHPKoOIMFjlgkp1yLgXv-X0qpruo5-6uPRPsdnPf1CjdKkWR';

void push() async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{'body': 'hhhh', 'title': 'title1'},
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to':
          'fS3TCNHuS4WrsKCRvoxa6j:APA91bH_8_Wpaj7pq_7HSOKuueyWyP5WBhflynBXsfbu-r-Y0fzaXvO-qJgUvFV2CRcVJecB1en0Zw_pX2KLaZTqq_9HUf77OOQ1NPxKy9cWJs8v7Fag6EaSilIgGNilXCcpAneqsaks',
      //db에서 친구 token 넣어주기!! //Friend Token
    }),
  );
}
void sendFriendRequest() async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{'body': '님이 친구를 요청했습니다', 'title': '친구 요청'},
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': '',
      //db에서 친구 token 넣어주기!! //Friend Token
    }),
  );
}
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: InkWell(
          child: Text('click here!'),
          onTap: () {
            push();
          },
        ),
      ),
    );
  }
}
