import 'package:ddayboo/hive.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? countFromZero;
  final TextEditingController _loveTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountFromZeroSetting();
  }

  _loadCountFromZeroSetting() async {
    bool? value = await HiveHelper.getCountFromZeroSetting();
    setState(() {
      countFromZero = value ?? false;
    });
  }

  _saveCountFromZeroSetting(bool value) async {
    await HiveHelper.saveCountFromZeroSetting(value);
    setState(() {
      countFromZero = value;
    });
  }

  _loadLoveText() async {
    String? text = await HiveHelper.getLoveText();
    _loveTextController.text = text ?? "";
  }

  _saveLoveText(String text) async {
    if (text.length <= 10) {
      await HiveHelper.saveLoveText(text);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("문구는 10자 이내로 작성해주세요.")));
    }
  }

  // 초기화 함수
  _resetAllData() async {
    await HiveHelper.resetAllData();
    _loadCountFromZeroSetting();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("데이터가 초기화되었습니다.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 179, 219),
        title: Text(
          '환경설정',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              '0일부터 세기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Switch(
              value: countFromZero ?? false,
              onChanged: (value) {
                _saveCountFromZeroSetting(value);
              },
              activeColor: Colors.pink,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              '상단 문구 수정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await _loadLoveText();
              // ignore: use_build_context_synchronously
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('상단 문구 수정'),
                      content: TextField(
                        controller: _loveTextController,
                        maxLength: 10,
                        decoration: InputDecoration(hintText: '상단 문구 입력'),
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
                          onPressed: () {
                            _saveLoveText(_loveTextController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              '초기화',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('초기화'),
                    content: Text('정말로 초기화 하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('확인'),
                        onPressed: () {
                          _resetAllData();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
