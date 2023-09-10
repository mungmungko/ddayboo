import 'package:flutter/material.dart';
import 'package:ddayboo/hive.dart';

// List
class ListTileApp_2 extends StatelessWidget {
  const ListTileApp_2({Key? key}) : super(key: key); // 여기를 수정하였습니다.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const ListTileExample(),
    );
  }
}

class ListTileExample extends StatefulWidget {
  const ListTileExample({Key? key}) : super(key: key);

  @override
  _ListTileExampleState createState() => _ListTileExampleState();
}

class _ListTileExampleState extends State<ListTileExample> {
  DateTime? selectedDate;
  int? dDay;
  List<Anniversary> anniversaries = [];

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  _loadDate() async {
    selectedDate = await HiveHelper.getDate();
    if (selectedDate != null) {
      dDay = DateTime.now().difference(selectedDate!).inDays;
      anniversaries =
          await generateAnniversaries(selectedDate); // 여기서 기념일 목록을 로드합니다.
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '스토리',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: ListView.builder(
        itemCount: anniversaries.length,
        itemBuilder: (context, index) {
          final anniversary = anniversaries[index];
          final daysRemaining =
              anniversary.date.difference(DateTime.now()).inDays;
          final subtitle = anniversary.birthdayOf != null
              ? " | ${anniversary.birthdayOf}님의 생일 🎂"
              : "";

          return Card(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${anniversary.title}$subtitle",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${anniversary.date.year}.${anniversary.date.month}.${anniversary.date.day}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "D $daysRemaining",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 💛💛💛
// 기념일
class Anniversary {
  String title;
  final DateTime date;
  String? birthdayOf; // 연인의 이름을 저장 (생일일 경우)

  Anniversary(this.title, this.date, {this.birthdayOf});
}

// 기념일 목록을 구축하고 정렬
Future<List<Anniversary>> generateAnniversaries(DateTime? startDate) async {
  final now = DateTime.now();
  final anniversaries = <Anniversary>[];

  if (startDate == null) return anniversaries;

  // 연인들의 생일 추가
  DateTime? lover1Birthday = await HiveHelper.getLover1Birthday();
  DateTime? lover2Birthday = await HiveHelper.getLover2Birthday();
  String? lover1Name = await HiveHelper.getLover1Name();
  String? lover2Name = await HiveHelper.getLover2Name();

  if (lover1Birthday != null && lover1Name != null) {
    for (int i = 0; i <= 36500 / 365; i++) {
      final date = DateTime(
          lover1Birthday.year + i, lover1Birthday.month, lover1Birthday.day);
      if (date.isAfter(startDate) &&
          date.isBefore(now.add(Duration(days: 36500)))) {
        anniversaries.add(Anniversary("🥳", date, birthdayOf: lover1Name));
      }
    }
  }

  if (lover2Birthday != null && lover2Name != null) {
    for (int i = 0; i <= 36500 / 365; i++) {
      final date = DateTime(
          lover2Birthday.year + i, lover2Birthday.month, lover2Birthday.day);
      if (date.isAfter(startDate) &&
          date.isBefore(now.add(Duration(days: 36500)))) {
        anniversaries.add(Anniversary("🥳", date, birthdayOf: lover2Name));
      }
    }
  }

  for (int i = 100; i <= 36500; i += 100) {
    final date = startDate.add(Duration(days: i));
    if (date.isBefore(now.add(Duration(days: 36500)))) {
      anniversaries.add(Anniversary("${i}일", date));
    }
  }

  for (int i = 1; i <= 100; i++) {
    final date = DateTime(startDate.year + i, startDate.month, startDate.day);
    if (date.isBefore(now.add(Duration(days: 36500)))) {
      anniversaries.add(Anniversary("${i}주년", date));
    }
  }

  anniversaries.sort((a, b) => a.date.compareTo(b.date));

  // 중복 검사 및 병합
  for (int i = 0; i < anniversaries.length - 1; i++) {
    if (anniversaries[i].date == anniversaries[i + 1].date) {
      if (anniversaries[i].birthdayOf != null) {
        anniversaries[i].title += " | ${anniversaries[i + 1].title}";
      } else {
        anniversaries[i + 1].title += " | ${anniversaries[i].title}";
      }
      anniversaries.removeAt(i);
      i--; // 중복을 다시 검사
    }
  }

  return anniversaries;
}
