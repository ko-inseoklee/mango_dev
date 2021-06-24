import 'package:flutter/material.dart';

class RefrigeratorPage extends StatefulWidget {
  final String title;

  const RefrigeratorPage({Key? key, required this.title}) : super(key: key);

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(_.tabIndex.toString()),
            // TextButton(
            //     onPressed: () =>
            //         print("here in homepage : ${_.tabIndex.value}"),
            //     child: Text('find currentIdx')),
            // TextButton(
            //     onPressed: () async =>
            //         await _.FindRefrigeratorSnapshot('1234'),
            //     child: Text('fetch ref'))
          ],
        ),
      ),
    );
  }
}
