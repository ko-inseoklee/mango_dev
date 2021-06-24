import 'package:flutter/material.dart';
import 'package:mangodevelopment/app.dart';
import 'package:mangodevelopment/color.dart';

class MangoAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? actions;

  MangoAppBar({Key? key, required this.title, this.actions})
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
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      actions: widget.actions,
      actionsIconTheme: Theme.of(context).iconTheme,
    );
  }
}
