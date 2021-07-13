import 'package:flutter/material.dart';

import '../../app.dart';
import '../../color.dart';

class MangoDivider extends StatelessWidget {
  const MangoDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0 * deviceHeight / prototypeHeight,
      decoration: BoxDecoration(
          color: MangoBehindColor,
          border: Border(top: BorderSide(color: MangoDisabledColorLight))),
    );
  }
}
