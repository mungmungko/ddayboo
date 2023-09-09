import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ddayboo/widgets/date_display_widget.dart';
import 'package:ddayboo/utils/date_picker_utils.dart';
import 'package:ddayboo/screens/events_list_screen.dart';
import 'package:ddayboo/widgets/birthday_popup.dart';
import 'package:ddayboo/screens/drawer_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 변경됨
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
      // 변경됨
      body: PageView(
        controller: _pageController,
        children: [
          MyHomePage(),
          EventsListScreen(),
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
  DateTime? startDate;
  int? daysDifference;

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
        startDate = storedDate;
        final currentDate = DateTime.now();
        daysDifference = currentDate.difference(storedDate).inDays;
      });
    }
  }

  void _handleDateSelected(DateTime newDate) async {
    final box = await Hive.openBox('myBox');
    box.put('startDate', newDate);

    setState(() {
      startDate = newDate;
      final currentDate = DateTime.now();
      daysDifference = currentDate.difference(newDate).inDays;
    });
  }

  void _showDatePicker() async {
    pickDate(context, _handleDateSelected);
  }

  void _showBirthdayPopup() {
    showDialog(
      context: context,
      builder: (context) => BirthdayPopup(),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerMenu(
        showDatePicker: _showDatePicker,
        showBirthdayPopup: _showBirthdayPopup,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateDisplayWidget(
                  daysDifference: daysDifference,
                  startDate: startDate,
                ),
                // CupertinoButton(
                //   child: Icon(
                //     CupertinoIcons.add,
                //     color: Colors.black,
                //   ),
                //   onPressed: _showBirthdayPopup,
                // ),
              ],
            ),
            Positioned(
              top: 50.0,
              left: 10.0,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
