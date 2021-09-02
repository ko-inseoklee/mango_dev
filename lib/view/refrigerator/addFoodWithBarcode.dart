import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class addFoodWithBarcode extends StatefulWidget {
  const addFoodWithBarcode({Key? key}) : super(key: key);

  @override
  _addFoodWithBarcodeState createState() => _addFoodWithBarcodeState();
}

class _addFoodWithBarcodeState extends State<addFoodWithBarcode> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(onPressed: () async{ test(); },
      child: Text('click'),

      ),
    );
  }

  Future<void> test() async{
    var response = await Dio().get('http://openapi.foodsafetykorea.go.kr/api/1e16e12da473496cb31c/건강기능식품 영양DB/xml/1/5').then((value) => print(value == '$value'));

  }
}
