import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback showDatePicker;
  final VoidCallback showBirthdayPopup; // 콜백을 추가합니다.

  DrawerMenu({required this.showDatePicker, required this.showBirthdayPopup});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('사용자 이름'),
            accountEmail: Text('example@email.com'),
            currentAccountPicture: CircleAvatar(
                //backgroundImage: AssetImage('assets/path_to_image.jpg'),
                ),
          ),
          ListTile(
            title: Text('커플이 된 날 변경'),
            onTap: () {
              Navigator.pop(context); // 드로어를 닫습니다.
              showDatePicker(); // 날짜 선택기를 표시합니다.
            },
          ),
          ListTile(
            title: Text('생일 추가하기'),
            onTap: () {
              Navigator.pop(context);
              showBirthdayPopup(); // 생일 팝업을 표시합니다.
            },
          ),
          // 다른 메뉴 항목들...
        ],
      ),
    );
  }
}
