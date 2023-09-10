import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static const String boxName = 'dDayBox';
  static const String dDayKey = 'dDay';
  static const String lover1NameKey = 'lover1Name';
  static const String lover1BirthdayKey = 'lover1Birthday';
  static const String lover2NameKey = 'lover2Name';
  static const String lover2BirthdayKey = 'lover2Birthday';

  static Future<void> initHive() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  // 커플이 된 날짜 쓰기
  static Future<void> saveDate(DateTime date) async {
    final box = await Hive.openBox(boxName);
    await box.put(dDayKey, date.toIso8601String());
    await box.close();
  }

  // 커플이 된 날짜 읽기
  static Future<DateTime?> getDate() async {
    final box = await Hive.openBox(boxName);
    final dateStr = box.get(dDayKey);
    await box.close();
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // 연인 1의 이름 저장
  static Future<void> saveLover1Name(String name) async {
    final box = await Hive.openBox(boxName);
    await box.put(lover1NameKey, name);
    await box.close();
  }

  // 연인 1의 생일 저장
  static Future<void> saveLover1Birthday(DateTime birthday) async {
    final box = await Hive.openBox(boxName);
    await box.put(lover1BirthdayKey, birthday.toIso8601String());
    await box.close();
  }

  // 연인 2의 이름 저장
  static Future<void> saveLover2Name(String name) async {
    final box = await Hive.openBox(boxName);
    await box.put(lover2NameKey, name);
    await box.close();
  }

  // 연인 2의 생일 저장
  static Future<void> saveLover2Birthday(DateTime birthday) async {
    final box = await Hive.openBox(boxName);
    await box.put(lover2BirthdayKey, birthday.toIso8601String());
    await box.close();
  }

  // 연인 1의 이름 불러오기
  static Future<String?> getLover1Name() async {
    final box = await Hive.openBox(boxName);
    final name = box.get(lover1NameKey);
    await box.close();
    return name;
  }

  // 연인 1의 생일 불러오기
  static Future<DateTime?> getLover1Birthday() async {
    final box = await Hive.openBox(boxName);
    final birthdayStr = box.get(lover1BirthdayKey);
    await box.close();
    return birthdayStr != null ? DateTime.parse(birthdayStr) : null;
  }

  // 연인 2의 이름 불러오기
  static Future<String?> getLover2Name() async {
    final box = await Hive.openBox(boxName);
    final name = box.get(lover2NameKey);
    await box.close();
    return name;
  }

  // 연인 2의 생일 불러오기
  static Future<DateTime?> getLover2Birthday() async {
    final box = await Hive.openBox(boxName);
    final birthdayStr = box.get(lover2BirthdayKey);
    await box.close();
    return birthdayStr != null ? DateTime.parse(birthdayStr) : null;
  }
}
