import 'package:flutter/material.dart';
import 'package:ddayboo/hive.dart'; // HiveHelper를 사용하기 위한 import

class Lover1DialogHelper {
  static Future<void> showLover1BirthdayDialog(BuildContext context) async {
    String? existingName = await HiveHelper.getLover1Name();
    DateTime? existingBirthday = await HiveHelper.getLover1Birthday();

    // 기본값 설정
    existingName ??= '북북';
    existingBirthday ??= DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) => Lover1BirthdayDialog(
        existingName: existingName!,
        existingBirthday: existingBirthday,
      ),
    );
  }
}

class Lover1BirthdayDialog extends StatefulWidget {
  final String existingName;
  final DateTime? existingBirthday;

  Lover1BirthdayDialog({required this.existingName, this.existingBirthday});

  @override
  _Lover1BirthdayDialogState createState() => _Lover1BirthdayDialogState();
}

class _Lover1BirthdayDialogState extends State<Lover1BirthdayDialog> {
  late TextEditingController loverNameController;
  DateTime? newLoverBirthday;

  @override
  void initState() {
    super.initState();
    loverNameController = TextEditingController(text: widget.existingName);
    newLoverBirthday = widget.existingBirthday;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '이름 및 생일 입력',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          // fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: loverNameController,
              decoration: InputDecoration(hintText: '이름'),
            ),
            TextField(
              controller: TextEditingController(
                  text: newLoverBirthday?.toLocal().toString().split(' ')[0]),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: newLoverBirthday ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    newLoverBirthday = date;
                  });
                }
              },
              decoration: InputDecoration(hintText: '생일 선택'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('저장'),
          onPressed: () async {
            await HiveHelper.saveLover1Name(loverNameController.text);
            await HiveHelper.saveLover1Birthday(newLoverBirthday!);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
