import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mangodevelopment/view/recognize/recognizedResult.dart';
import 'package:mangodevelopment/view/widget/dialog/editProfileImageDialog.dart';

import '../../ignore.dart';

class BarcodeFromGallery extends StatelessWidget {
  BarcodeFromGallery({Key? key}) : super(key: key);

  late var inputImage;
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  late List<Barcode> barcodes;
  List<String> barcodeResults = [];
  List<String> results = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(20.0))),
      title: Container(
          width: ScreenUtil().setWidth(300),
          child: Center(child: Text('바코드 인식'))),
      content: editProfileImageDialog(onTapCamera: (){}, onTapGallery: () async {
        await getGalleryImage().then((value) async {
          inputImage = InputImage.fromFilePath(value);
          barcodes = await barcodeScanner.processImage(inputImage);

          print("done");

          late Map<String, dynamic> parsedData;

          for(Barcode barcode in barcodes){
            Response response = await Dio()
                .get(
                'https://openapi.foodsafetykorea.go.kr/api/$scanBarcodeKey/C005/json/1/5/BAR_CD=${barcode.barcodeUnknown!.displayValue}');

            print('status code == ${response.statusCode}');


            if(response.statusCode == 200){
              print("start add ");
              print(response.data);
              parsedData = response.data['C005'];
              print(parsedData);
              // results.add(response.data.toString());
            }
          }

          g.Get.back();
          g.Get.dialog(RecognizedResult(result: parsedData,));

          //     .then((value) {
          // String data = value.toString();
          // Map<String, dynamic> parsedData = jsonDecode(data);
          // print(parsedData['C005']['row']);
          // // print(parsedData['C005']['row'][0]['POG_DAYCNT']);
          // results.add(value.toString());
          // // print(value);
          // Get.back();
          // Get.bottomSheet(RecognizedResult(results: results,));
          // });



          // print("barcode == $barcodes");


        });
      }),
    );
  }
}
