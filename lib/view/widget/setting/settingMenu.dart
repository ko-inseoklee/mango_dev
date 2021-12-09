import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../color.dart';

class settingMenu extends StatefulWidget {
  final String menuName;
  final VoidCallback onTap;
  final Widget trailing;
  final int trailingWidth;
  final bool isActive;

  const settingMenu({
    Key? key,
    required this.menuName,
    required this.onTap,
    required this.trailing,
    required this.trailingWidth,
    required this.isActive,
    // this.isActive = true
  }) : super(key: key);

  @override
  _settingMenuState createState() => _settingMenuState();
}

class _settingMenuState extends State<settingMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: MangoDisabledColor),
              ),
              color: Colors.white,
            ),
            child: Column(
          children: [
            ListTile(
              title: Text(
                widget.menuName,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: widget.isActive ? MangoBlack : MangoDisabledColor,
                    ),
                textAlign: TextAlign.left,
              ),
              onTap: widget.onTap,
              trailing: widget.trailing == null
                  ? SizedBox()
                  : Container(
                      width:
                          widget.trailingWidth * deviceWidth / prototypeWidth,
                      alignment: Alignment.center,
                      child: widget.trailing,
                    ),
            ),
          ],
        )));
  }
}
