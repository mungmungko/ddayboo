import 'package:flutter/material.dart';
import 'package:ddayboo/hive.dart'; // HiveHelper를 사용하기 위한 import

class Lover2DialogHelper {
  static Future<void> showLover2BirthdayDialog(BuildContext context) async {
    String? existingName = await HiveHelper.getLover2Name();
    DateTime? existingBirthday = await HiveHelper.getLover2Birthday();

    // 기본값 설정
    existingName ??= '북박';
    existingBirthday ??= DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) => Lover2BirthdayDialog(
        existingName: existingName!,
        existingBirthday: existingBirthday,
      ),
    );
  }
}

class Lover2BirthdayDialog extends StatefulWidget {
  final String existingName;
  final DateTime? existingBirthday;

  Lover2BirthdayDialog({required this.existingName, this.existingBirthday});

  @override
  _Lover2BirthdayDialogState createState() => _Lover2BirthdayDialogState();
}

class _Lover2BirthdayDialogState extends State<Lover2BirthdayDialog> {
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
            await HiveHelper.saveLover2Name(loverNameController.text);
            await HiveHelper.saveLover2Birthday(newLoverBirthday!);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
