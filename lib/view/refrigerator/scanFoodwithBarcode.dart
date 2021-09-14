import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/ignore.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:uuid/uuid.dart';

class addFoodWithBarcode extends StatefulWidget {
  final List<String> scanedBarcode;

  const addFoodWithBarcode({Key? key,required this.scanedBarcode}) : super(key: key);



  @override
  _addFoodWithBarcodeState createState() => _addFoodWithBarcodeState();
}

class _addFoodWithBarcodeState extends State<addFoodWithBarcode> {

  late RefrigeratorViewModel _refrigerator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    _refrigerator = Get.find<RefrigeratorViewModel>();

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: test(),
            builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return CircularProgressIndicator();
          } else if(snapshot.hasData == false){
            return Text('값이 없습니다.');
          }else{
            return Text(snapshot.data.toString());
          }
        }),
      ),
      );
  }

  Future<List<String>> test() async{
    List<String> result = [];
    try{
      for (String barcode in widget.scanedBarcode){
        print("실행 중..");
        var response = await Dio().get('https://openapi.foodsafetykorea.go.kr/api/$scanBarcodeKey/C005/json/1/5/BAR_CD=$barcode').then((value)
        {
          String data = value.toString();
          Map<String, dynamic> parsedData = jsonDecode(data);
          print(parsedData['C005']['row']);
          // print(parsedData['C005']['row'][0]['POG_DAYCNT']);
          result.add(value.toString());
          // print(value);

        });
      }

      return result;
    }catch (e){
      print(e);
      return result;
    }
  }

  Food makeFoodFromBarcode({required String data}){
    Map<String, dynamic> parsedData = jsonDecode(data);
    String shelfLife = parsedData['C005']['row'][0]['POG_DAYCNT'];
    int shelf = 0;
    DateTime shelfL = DateTime.now();
    if(shelfLife.contains('일')){
      shelfLife.replaceAll(new RegExp(r'[^0-9]'),'');
      shelf = int.parse(shelfLife);
      shelfL = DateTime.now().add(Duration(days: shelf));
    } else if(shelfLife.contains('개월') || shelfLife.contains('달')){

    } else{

    }
    Food result = new Food(fId: Uuid().v4(), rId: _refrigerator.ref.value.rID, index: 0, status: false, name: parsedData['C005']['row'][0]['PRDLST_NM'], num: 1, category: '-1', method: 0, displayType: true, shelfLife: shelfL, registrationDay: DateTime.now(), alarmDate: alarmDate, cardStatus: 1)

    return result;
  }
}
