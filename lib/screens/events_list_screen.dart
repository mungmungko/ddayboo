import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventsListScreen extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  _loadStartDate() async {
    final box = await Hive.openBox('myBox');
    DateTime? storedDate = box.get('startDate');

    if (storedDate != null) {
      setState(() {
        selectedDate = storedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('스토리'),
        ),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: Hive.box('myBox').listenable(),
            builder: (context, Box box, _) {
              DateTime? startDate = box.get('startDate');
              String? savedName1 = box.get('name1');
              String? savedName2 = box.get('name2');
              DateTime? birthday1 = box.get('birthday1');
              DateTime? birthday2 = box.get('birthday2');

              if (startDate != null) {
                return ListView(
                  children: _buildEventTiles(
                    startDate,
                    savedName1,
                    savedName2,
                    birthday1,
                    birthday2,
                  ),
                );
              } else {
                return Text('날짜를 설정해주세요');
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEventTiles(
    DateTime startDate,
    String? savedName1,
    String? savedName2,
    DateTime? birthday1,
    DateTime? birthday2,
  ) {
    List<Widget> tiles = [];
    DateTime today = DateTime.now();

    // 생일 및 기념일의 날짜 및 정보를 담을 List 생성
    List<EventDetail> events = [];

    // 커플이 된 날 추가
    int daysSinceStart = today.difference(startDate).inDays;
    String daysTextForStart = daysSinceStart == 0
        ? '오늘'
        : (daysSinceStart > 0 ? '-$daysSinceStart' : '$daysSinceStart');

    events
        .add(EventDetail('커플이 된 날', startDate, daysTextForStart, GlobalKey()));

    // 생일 데이터 추가
    if (birthday1 != null) {
      for (var event in _generateBirthdayEvents(
          savedName1!, birthday1, startDate, today)) {
        events.add(event);
      }
    }
    if (birthday2 != null) {
      for (var event in _generateBirthdayEvents(
          savedName2!, birthday2, startDate, today)) {
        events.add(event);
      }
    }

    // 기념일 데이터 추가
    for (int i = 1; i <= 36525; i++) {
      DateTime anniversary = startDate.add(Duration(days: i));
      int daysRemaining = anniversary.difference(today).inDays;
      String daysText = daysRemaining == 0
          ? '오늘'
          : (daysRemaining > 0 ? '+$daysRemaining' : '$daysRemaining');

      if (i % 100 == 0) {
        events.add(EventDetail('$i일', anniversary, daysText, GlobalKey()));
      } else if (i % 365 == 0) {
        events.add(
            EventDetail('${i ~/ 365}년', anniversary, daysText, GlobalKey()));
      }
    }

    // 날짜별로 정렬
    events.sort((a, b) => a.date.compareTo(b.date));

    // 위젯 생성
    bool upcomingEventShown = false;
    for (var event in events) {
      if (!upcomingEventShown && event.daysText[0] == '+') {
        upcomingEventShown = true;
      }
      tiles.add(_generateEventTile(event));
    }

    return tiles;
  }

  Widget _generateEventTile(EventDetail eventDetail) {
    DateTime today = DateTime.now();
    bool isPast = eventDetail.date.isBefore(today);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eventDetail.label,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: isPast ? Colors.grey : Colors.black,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${eventDetail.date.year}.${eventDetail.date.month}.${eventDetail.date.day}',
                    style: TextStyle(
                      fontSize: 13.0,
                      // fontWeight: FontWeight.bold,
                      color: isPast ? Colors.grey : Colors.black,
                    ),
                  ),
                  Text(
                    'D ' + eventDetail.daysText,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: isPast ? Colors.grey : Colors.pink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  List<EventDetail> _generateBirthdayEvents(
      String name, DateTime birthday, DateTime startDate, DateTime today) {
    List<EventDetail> events = [];

    DateTime nextBirthday = DateTime(today.year, birthday.month, birthday.day);
    if (today.isAfter(nextBirthday) || today.isAtSameMomentAs(nextBirthday)) {
      nextBirthday = DateTime(today.year + 1, birthday.month, birthday.day);
    }

    for (int i = 0; i < 100; i++) {
      DateTime upcomingBirthday =
          DateTime(nextBirthday.year + i, nextBirthday.month, nextBirthday.day);

      int daysSinceStartDate = upcomingBirthday.difference(startDate).inDays;
      int daysRemaining = upcomingBirthday.difference(today).inDays;
      String daysText = daysRemaining == 0
          ? '오늘'
          : (daysRemaining > 0 ? '+$daysRemaining' : '$daysRemaining');

      events.add(EventDetail('${daysSinceStartDate}일 ${name}님의 생일 🎂',
          upcomingBirthday, daysText, GlobalKey()));
    }

    return events;
  }
}

class EventDetail {
  final String label;
  final DateTime date;
  final String daysText;
  final GlobalKey key;

  EventDetail(this.label, this.date, this.daysText, this.key);
}
