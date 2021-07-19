import 'package:flutter/material.dart';

class MangoPostCard extends StatelessWidget {
  String food;
  String owner;
  int min;
  String text;
  int num;
  DateTime due;

  MangoPostCard(
      {Key? key,
      required String food,
      required String owner,
      required int min,
      required String text,
      required int num,
      required DateTime due})
      : food = food,
        owner = owner,
        min = min,
        text = text,
        num = num,
        due = due;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey, width: 1),
      // ),
      // borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 45,
                  // backgroundImage:
                  backgroundColor: Colors.grey[200],
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: (min < 60)
                        ? Text(
                            '$min분 전',
                          )
                        : Text(
                            '${min ~/ 60}시간 전',
                          ),
                  ),
                  Text(
                    food + '  $num개',
                  ),
                  Text(
                    '유통기한 ${due.year}.${due.month}.${due.day}',
                  ),
                  Text(
                    text,
                  ),
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          radius: 20,
                          // backgroundImage:
                          backgroundColor: Colors.grey,
                        ),
                        margin: EdgeInsets.only(right: 25),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          // color: Orange100,
                          child: Icon(Icons.call),
                          onPressed: () {
                            print('call');
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.yellow)))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          // color: Theme.of(context).accentColor,
                          child: Icon(Icons.send_rounded),
                          // onPressed: () => showAlertDialog('치즈', 3, '2021.1.30'),
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.yellow)))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
