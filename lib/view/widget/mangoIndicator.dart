import 'package:flutter/material.dart';

class MangoCircularIndicator extends StatelessWidget {
  const MangoCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
