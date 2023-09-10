import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static const String boxName = 'dDayBox';
  static const String dDayKey = 'dDay';
  static const String lover1NameKey = 'lover1Name';
  static const String lover1BirthdayKey = 'lover1Birthday';
  static const String lover2NameKey = 'lover2Name';
  static const String lover2BirthdayKey = 'lover2Birthday';
  static const String countFromZeroKey = 'countFromZero';
  static const String loveTextKey = 'loveText';

  static Future<void> initHive() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  // 초기화
  static Future<void> resetAllData() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
    await box.close();
  }

  // 커플이 된 날짜 저장
  static Future<void> saveDate(DateTime date) async {
    final box = await Hive.openBox(boxName);
    await box.put(dDayKey, date.toIso8601String());
    await box.close();
  }

  // 커플이 된 날짜 불러오기
  static Future<DateTime> getDate() async {
    final box = await Hive.openBox(boxName);
    final dateStr = box.get(dDayKey);
    await box.close();

    return dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
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
  static Future<String> getLover1Name() async {
    final box = await Hive.openBox(boxName);
    String? name = box.get(lover1NameKey);
    await box.close();

    if (name == null) {
      await saveLover1Name('북북');
      name = '북북';
    }

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
  static Future<String> getLover2Name() async {
    final box = await Hive.openBox(boxName);
    String? name = box.get(lover2NameKey);
    await box.close();

    return name ?? '복복';
  }

  // 연인 2의 생일 불러오기
  static Future<DateTime?> getLover2Birthday() async {
    final box = await Hive.openBox(boxName);
    final birthdayStr = box.get(lover2BirthdayKey);
    await box.close();
    return birthdayStr != null ? DateTime.parse(birthdayStr) : null;
  }

  // '0일부터 세기' 설정 저장하기
  static Future<void> saveCountFromZeroSetting(bool value) async {
    final box = await Hive.openBox(boxName);
    await box.put(countFromZeroKey, value);
    await box.close();
  }

// '0일부터 세기' 설정 불러오기 값이 null일 경우 'false'를 저장한다
  static Future<bool> getCountFromZeroSetting() async {
    final box = await Hive.openBox(boxName);
    bool? value = box.get(countFromZeroKey);
    await box.close();
    return value ?? false;
  }

  // 상단 문구 저장하기
  static Future<void> saveLoveText(String text) async {
    final box = await Hive.openBox(boxName);
    await box.put(loveTextKey, text);
    await box.close();
  }

// 상단 문구 불러오기 값이 null일 경우 '우리 커플'을 저장한다
  static Future<String?> getLoveText() async {
    final box = await Hive.openBox(boxName);
    String? text = box.get(loveTextKey);
    await box.close();

    if (text == null) {
      await saveLoveText('우리 커플'); // 값이 없을 때 '우리 커플'로 저장
      return '우리 커플';
    }
    return text;
  }
}
