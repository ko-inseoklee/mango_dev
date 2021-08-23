import 'package:flutter/material.dart';

import '../../../color.dart';

class MangoFloatingActionButton extends StatelessWidget {
  final int currentPage;
  final VoidCallback onPressed;
  const MangoFloatingActionButton(
      {Key? key, required this.currentPage, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(currentPage == 1 ? Icons.create : Icons.add),
      backgroundColor: Orange400,
    );
  }
}
