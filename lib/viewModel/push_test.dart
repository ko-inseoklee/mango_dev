import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addFriendViewModel.dart';

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
