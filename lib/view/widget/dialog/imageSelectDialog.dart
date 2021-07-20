import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';

import '../../../app.dart';
import 'imageSelectCard.dart';

class ImageSelectDialog extends StatelessWidget {
  UserViewModel _userViewModelController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Container(
          width: deviceWidth, child: Center(child: Text('프로필 사진 수정'))),
      content: Container(
        height: 150 * (deviceWidth / prototypeWidth),
        child: imageSelectCard(
          onTapCamera: () {},
          onTapGallery: () async {
            await getGalleryImage().then((value) {
              _userViewModelController.user.value.profileImageReference = value;
            });
            Get.back();
          },
        ),
      ),
    );
  }
}
