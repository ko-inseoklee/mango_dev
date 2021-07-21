import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';


class FileStorage extends GetxController {
  late FirebaseStorage storage; //= FirebaseStorage.instance; //storage instance
  late Reference storageRef; //= storage.ref().child(''); //storage

  FileStorage() {
    storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile(String filePath, String uploadPath) async {
    File file = File(filePath);

    try {
      storageRef = storage.ref(uploadPath);
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return '-1';
    }
  }

  Future<void> handleTaskExample3(String filePath, String uploadPath) async {
    File largeFile = File(filePath);

    UploadTask task = storage
        .ref(uploadPath)
        .putFile(largeFile);

    // Pause the upload.
    bool paused = await task.pause();
    print('paused, $paused');

    // Resume the upload.
    bool resumed = await task.resume();
    print('resumed, $resumed');

    // Cancel the upload.
    bool canceled = await task.cancel();
    print('canceled, $canceled');

    // ...
  }

}