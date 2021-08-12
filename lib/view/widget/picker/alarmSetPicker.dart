// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mangodevelopment/view/widget/dialog/dialog.dart';
// import 'package:get/get.dart';
//
// class AlarmSetPicker extends StatefulWidget {
//   final String title;
//   final int firstIndex;
//   final int type;
//
//   const AlarmSetPicker(
//       { //Key key,
//         required this.title,
//         required this.firstIndex,
//         required this.type,});
//   @override
//   _AlarmSetPickerState createState() => _AlarmSetPickerState();
// }
//
// class _AlarmSetPickerState extends State<AlarmSetPicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Future<dynamic> showModalBottomSheet(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(30.0),
//                 topRight: const Radius.circular(30.0),
//               )),
//           context: context,
//           builder: (BuildContext builder) {
//             return Container(
//               height: ScreenUtil().setHeight(284),
//               child: Column(
//                 children: [
//                   dialogTopBar(),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       '알림일 설정',
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6, //TODO. CHANGE NEXT TIME
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTapDown: (details) {
//                         if (alarmIdx < 2 && alarmIdx == type) {
//                           setState(() {
//                             alarmIdx++;
//                           });
//                         }
//                         Get.back();
//                       },
//                       child: CupertinoPicker(
//                         itemExtent: 32,
//                         onSelectedItemChanged: (int newValue) {
//                           print(newValue);
//                           setState(() {
//                             type == 0
//                                 ? _refrigerationAlarm = newValue + 1
//                                 : type == 1
//                                 ? _frozenAlarm = newValue + 1
//                                 : _roomTempAlarm = newValue + 1;
//                           });
//                         },
//                         children: List<Widget>.generate(60, (int index) {
//                           return Text(
//                             (++index).toString(),
//                             style: Theme.of(context).textTheme.headline5,
//                           );
//                         }),
//                         scrollController: FixedExtentScrollController(
//                           //initialItem: foods[index - 1].num - 1
//                             initialItem: 1),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });
//     }
//   }
// }
