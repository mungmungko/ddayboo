import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ddayboo/hive.dart';
import 'package:ddayboo/list_tile.dart';
import 'package:ddayboo/lover1_dialog.dart';
import 'package:ddayboo/lover2_dialog.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dayboo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          MyHomePage(),
          ListTileApp_2(),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedDate;
  int? dDay;
  String? lover1Name;
  String? lover2Name;
  DateTime? lover1Birthday;
  DateTime? lover2Birthday;

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  _loadDate() async {
    // 디데이 날짜 로드
    selectedDate = await HiveHelper.getDate();
    if (selectedDate != null) {
      dDay = DateTime.now().difference(selectedDate!).inDays;
    }

    // 연인1의 이름 및 생일 로드
    lover1Name = await HiveHelper.getLover1Name() ?? '연인1 이름을 입력하세요';
    lover1Birthday = await HiveHelper.getLover1Birthday();

    // 연인2의 이름 및 생일 로드
    lover2Name = await HiveHelper.getLover2Name() ?? '연인2 이름을 입력하세요';
    lover2Birthday = await HiveHelper.getLover2Birthday();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/bg_heart.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // D-Day Text // Date Text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4, // 예시 위치
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "우리 커플",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      dDay != null ? "$dDay일" : "날짜를 선택해주세요.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      selectedDate != null
                          ? DateFormat('yyyy.MM.dd').format(selectedDate!)
                          : " ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 날짜 Button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(context, onConfirm: (date) async {
                      await HiveHelper.saveDate(date);
                      _loadDate();
                    });
                  },
                  child: Image.asset(
                    'assets/image/sun.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            // 날짜 Button
            // Positioned(
            //   top: MediaQuery.of(context).size.height * 0.1, // 예시 위치
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: ElevatedButton(
            //       onPressed: () {
            //         DatePicker.showDatePicker(context, onConfirm: (date) async {
            //           await HiveHelper.saveDate(date);
            //           _loadDate();
            //         });
            //       },
            //       child: Text("날짜"),
            //     ),
            //   ),
            // ),
            // 연인1 Button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.7, // 예시 위치
              left: MediaQuery.of(context).size.width * 0.2, // 예시 위치
              child: InkWell(
                onTap: () async {
                  await Lover1DialogHelper.showLover1BirthdayDialog(context);
                  _loadDate();
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image/boo1.png',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      lover1Name != null ? "$lover1Name" : " ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 연인2 Button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.7, // 예시 위치
              right: MediaQuery.of(context).size.width * 0.2, // 예시 위치
              child: InkWell(
                onTap: () async {
                  await Lover2DialogHelper.showLover2BirthdayDialog(context);
                  _loadDate();
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image/boo2.png',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      lover2Name != null ? "$lover2Name" : " ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
