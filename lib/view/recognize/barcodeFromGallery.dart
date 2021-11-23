import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mangodevelopment/view/widget/dialog/editProfileImageDialog.dart';

class BarcodeFromGallery extends StatelessWidget {
  BarcodeFromGallery({Key? key}) : super(key: key);

  late var inputImage;
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  late List<Barcode> barcodes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: () {
            Get.dialog(
              AlertDialog(
                content: editProfileImageDialog(onTapCamera: (){}, onTapGallery: () async {
                  await getGalleryImage().then((value) async {
                    inputImage = InputImage.fromFilePath(value);
                    loadBarcodes(inputImage);
                  });
                }),
              )
            );
          }, child: Center(
            child: Text('바코드 확인'),
          ),
          ),
          // FutureBuilder(future: loadBarcodes(inputImage),builder: (context, snapshot){
          //   if(snapshot.connectionState == ConnectionState.none){
          //     return CircularProgressIndicator();
          //   }else if(snapshot.connectionState == ConnectionState.waiting){
          //     return CircularProgressIndicator();
          //   }else{
          //     return Column(
          //       children: [
          //         Container(
          //           child: Text(barcodes.first.barcodeType.toString()),
          //         )
          //       ],
          //     );
          //   }
          // }),
        ],
      ),
    );
  }

  Future<void> loadBarcodes(InputImage inputImage) async {
    if(inputImage != null) barcodes = await barcodeScanner.processImage(inputImage);
  }
}
