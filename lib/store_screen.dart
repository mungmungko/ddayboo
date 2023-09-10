import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 179, 219),
        title: Text(
          '🌈 꾸미기',
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
              '캐릭터1 변경',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: 캐릭터1 변경 로직을 여기에 추가하세요.
            },
          ),
          Divider(), // 리스트 항목 사이에 회색 줄 추가
          ListTile(
            title: Text(
              '캐릭터2 변경',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: 캐릭터2 변경 로직을 여기에 추가하세요.
            },
          ),
          Divider(), // 리스트 항목 사이에 회색 줄 추가
          ListTile(
            title: Text(
              '하트 변경',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: 하트 변경 로직을 여기에 추가하세요.
            },
          ),
        ],
      ),
    );
  }
}
