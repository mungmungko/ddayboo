import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BirthdayPopup extends StatefulWidget {
  @override
  _BirthdayPopupState createState() => _BirthdayPopupState();
}

class _BirthdayPopupState extends State<BirthdayPopup> {
  TextEditingController _name1Controller = TextEditingController();
  TextEditingController _name2Controller = TextEditingController();
  DateTime? _birthday1;
  DateTime? _birthday2;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  _loadSavedData() async {
    final box = await Hive.openBox('myBox');
    String? savedName1 = box.get('name1');
    String? savedName2 = box.get('name2');
    DateTime? savedBirthday1 = box.get('birthday1');
    DateTime? savedBirthday2 = box.get('birthday2');

    setState(() {
      _name1Controller.text = savedName1 ?? '';
      _name2Controller.text = savedName2 ?? '';
      _birthday1 = savedBirthday1;
      _birthday2 = savedBirthday2;
    });
  }

  _saveBirthdays() async {
    final box = await Hive.openBox('myBox');
    box.put('name1', _name1Controller.text);
    box.put('name2', _name2Controller.text);
    box.put('birthday1', _birthday1);
    box.put('birthday2', _birthday2);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('생일 추가하기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name1Controller,
            decoration: InputDecoration(labelText: '이름 1'),
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _birthday1 = pickedDate;
                });
              }
            },
            child: Text(_birthday1 != null
                ? '${_birthday1!.year}년 ${_birthday1!.month}월 ${_birthday1!.day}일'
                : '생일 선택'),
          ),
          TextField(
            controller: _name2Controller,
            decoration: InputDecoration(labelText: '이름 2'),
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _birthday2 = pickedDate;
                });
              }
            },
            child: Text(_birthday2 != null
                ? '${_birthday2!.year}년 ${_birthday2!.month}월 ${_birthday2!.day}일'
                : '생일 선택'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('취소')),
        TextButton(onPressed: _saveBirthdays, child: Text('저장')),
      ],
    );
  }
}
