import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mangodevelopment/model/food.dart';
import 'package:mangodevelopment/view/recognize/recognizedResult.dart';
import 'package:mangodevelopment/view/widget/dialog/editProfileImageDialog.dart';
import 'package:mangodevelopment/viewModel/refrigeratorViewModel.dart';
import 'package:uuid/uuid.dart';

import '../../ignore.dart';

class BarcodeFromGallery extends StatelessWidget {
  BarcodeFromGallery({Key? key}) : super(key: key);

  late var inputImage;
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  late List<Barcode> barcodes;
  List<String> barcodeResults = [];
  List<String> results = [];
  RefrigeratorViewModel refrigerator = g.Get.find<RefrigeratorViewModel>();

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

          var is_contain = '-1';

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
              is_contain = parsedData['total_count'];

              print(parsedData['row'][0]);
            }
          }

          if(is_contain == '0' || is_contain == '-1'){
            print("해당하는 바코드가 없습니다.");
            g.Get.back();
          }else{

            int mulDay = 1;
            String shelf = parsedData['row'][0]['POG_DAYCNT'];

            // 공백제거
            shelf = shelf.removeAllWhitespace;

            // 기간 추출
            if(shelf.contains('개월') || shelf.contains('달')) mulDay = 30;
            else if(shelf.contains('년')) mulDay = 365;
            else if(shelf.contains('주')) mulDay = 7;

            // 숫자 추출
            String iShelf = shelf.replaceAll(RegExp('[^0-9]'), '');

            int shelfCount = int.parse(iShelf) * mulDay;

            Food result = new Food(fId: Uuid().v4(), rId: refrigerator.ref.value.rID, index: 0, status: true, name: parsedData['row'][0]['PRDLST_NM'].toString(), num: 1, category: parsedData['row'][0]['PRDLST_DCNM'].toString(), method: 0, displayType: true, shelfLife: DateTime.now().add(Duration(days: shelfCount)), registrationDay: DateTime.now(), alarmDate: DateTime.now().add(Duration(days: shelfCount)), cardStatus: -1);


            g.Get.back();
            g.Get.dialog(RecognizedResult(result: result,));
          }

        });
      }),
    );
  }
}
