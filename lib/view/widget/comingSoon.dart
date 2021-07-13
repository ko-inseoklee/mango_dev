import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Coming Soon'),
      content: Container(
        height: 100,
        child: Center(child: Text('준비중 입니다.')),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('뒤로 가기'))
      ],
    );
  }
}
