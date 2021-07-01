import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/color.dart';

class MangoAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? actions;
  PreferredSizeWidget? bottom;
  bool isLeading;

  MangoAppBar(
      {Key? key,
      required this.title,
      this.actions,
      this.bottom,
      required this.isLeading})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _MangoAppBarState createState() => _MangoAppBarState();
}

class _MangoAppBarState extends State<MangoAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MangoWhite,
      leading: widget.isLeading
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: MangoBlack,
              ),
            )
          : Text(''),
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.w700),
      ),
      automaticallyImplyLeading: true,
      centerTitle: true,
      actions: widget.actions,
      actionsIconTheme: Theme.of(context).iconTheme,
      bottom: widget.bottom,
    );
  }
}
