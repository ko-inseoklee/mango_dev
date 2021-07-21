import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app.dart';
import '../../color.dart';

class MangoDivider extends StatelessWidget {
  const MangoDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(2),
      decoration: BoxDecoration(
          color: MangoBehindColor,
          border: Border(top: BorderSide(color: MangoDisabledColorLight))),
    );
  }
}
