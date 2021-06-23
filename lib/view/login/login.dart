import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  final title;

  const LogInPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
    );
  }
}
