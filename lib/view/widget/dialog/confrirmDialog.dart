import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmDialog extends StatefulWidget {
  final String contentText;
  final VoidCallback onTapOK;

  const ConfirmDialog({
    //Key key,
    required this.contentText,
    required this.onTapOK,
  });

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      content: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: ScreenUtil().setWidth(296),
          height: ScreenUtil().setHeight(150),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 1,),
            Text(
              widget.contentText,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1,),
            ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: ScreenUtil().setWidth(238),
                  height: ScreenUtil().setHeight(46),
                ),
                child: ElevatedButton(
                    onPressed: widget.onTapOK,
                    child: Text(
                      '확인',
                      style: Theme.of(context).textTheme.button,
                    ))),
          ],
        ),
      ),
    );
  }
}
