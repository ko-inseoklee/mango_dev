import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var serverToken =
    'AAAAA2rmKow:APA91bE0C2NC74vPLJfyyUrwBKsodxH--X4G30WqduS_DN0uAYM8J4c9k0FWNkSSd6aG8TUsZzihoFv-8cy75ydfaR-XeHPKoOIMFjlgkp1yLgXv-X0qpruo5-6uPRPsdnPf1CjdKkWR';

void sendFriendRequest(String friendToken) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': '님이 친구를 요청했습니다',
        'title': '친구 요청'
      },
      'priority': 'high',
      // 'data': <String, dynamic>{
      //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      //   'id': '1',
      //   'status': 'done'
      // },
      'to': 'cyF0RGWpTSqy9VAGa6a50H:APA91bFFf_c5X7ZLhUVlJcKldyHJqbp356nZjWjYRGj_OdZCqpdggY29inQ5Q7L0AnXKu_lqJ5VAw75IG9Eg9SmjviiPBNOrL7MxPJ_-uK5LDMlXhjn_GrRS5-wsRejS5gJLz_We5snE',
      // TODO: db에서 친구 token 넣어주기!! //Friend Token
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
            sendFriendRequest('cyF0RGWpTSqy9VAGa6a50H:APA91bFFf_c5X7ZLhUVlJcKldyHJqbp356nZjWjYRGj_OdZCqpdggY29inQ5Q7L0AnXKu_lqJ5VAw75IG9Eg9SmjviiPBNOrL7MxPJ_-uK5LDMlXhjn_GrRS5-wsRejS5gJLz_We5snE');
          },
        ),
      ),
    );
  }
}
