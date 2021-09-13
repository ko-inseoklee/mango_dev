import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mangodevelopment/ignore.dart';

class addFoodWithBarcode extends StatefulWidget {
  final List<String> scanedBarcode;

  const addFoodWithBarcode({Key? key,required this.scanedBarcode}) : super(key: key);



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
          result.add(value.toString());
          print(value);
        });
      }

      return result;
    }catch (e){
      print(e);
      return result;
    }
  }

  // List<Widget> buildScannedLists(){
  //   return null;
  // }
}
