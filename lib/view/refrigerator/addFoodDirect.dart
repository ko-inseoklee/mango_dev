import 'package:flutter/material.dart';
import 'package:mangodevelopment/view/widget/appBar.dart';

class AddFoodDirectPage extends StatefulWidget {
  final String title;
  const AddFoodDirectPage({Key? key, required this.title}) : super(key: key);

  @override
  _AddFoodDirectPageState createState() => _AddFoodDirectPageState();
}

class _AddFoodDirectPageState extends State<AddFoodDirectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MangoAppBar(
        isLeading: true,
        key: widget.key,
        title: widget.title,
      ),
    );
  }
}
