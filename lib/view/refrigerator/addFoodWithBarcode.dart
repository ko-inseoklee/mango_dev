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
      body: Center(
        child: TextButton(onPressed: () async{ test(); },
        child: Text('click'),

        ),
      ),
    );
  }

  Future<void> test() async{
    try{
      print("실행 중..");
      var response = await Dio().get('https://openapi.foodsafetykorea.go.kr/api/1e16e12da473496cb31c/C005/json/1/1/BAR_CD=8809360172165');
      print(response);

    }catch (e){

    }

  }
}
