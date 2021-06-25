import 'package:flutter/material.dart';

class MangoFloatingActionButton extends StatelessWidget {
  const MangoFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print('work well.');
      },
      child: Icon(Icons.add),
    );
  }
}
