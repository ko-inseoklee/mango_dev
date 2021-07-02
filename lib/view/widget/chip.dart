import 'package:flutter/material.dart';

class MangoChip extends StatelessWidget {
  String name = '-';
  MangoChip({Key? key, required String name}) : name = name;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(6.0, 0, 6.0, 0),
        child: Chip(
          label: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
          deleteButtonTooltipMessage: '삭제하시겠습니까?',
          deleteIcon: Icon(Icons.delete),
        ));
  }
}
