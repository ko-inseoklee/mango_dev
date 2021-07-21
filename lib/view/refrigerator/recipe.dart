import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangodevelopment/app.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipePage extends StatefulWidget {
  final String title;
  RecipePage({Key? key, required this.title}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: WebView(
            initialUrl: 'https://www.10000recipe.com/',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}
