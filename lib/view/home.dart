import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/model/refrigerator.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';

class HomePage extends StatelessWidget {
  final title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<RefrigeratorViewModel>(
      init: RefrigeratorViewModel(),
      builder: (_) {
        return Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_.refrigerator.value.refID),
              TextButton(
                  onPressed: () async =>
                      await _.FindRefrigeratorSnapshot('1234'),
                  child: Text('fetch ref'))
            ],
          ),
        ));
      },
    );
  }
}
