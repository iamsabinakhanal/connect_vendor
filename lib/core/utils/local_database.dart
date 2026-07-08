import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static const String authBoxName = 'auth_box';
  static const String chatBoxName = 'chat_box';
  static const String feedBoxName = 'feed_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(authBoxName);
    await Hive.openBox<dynamic>(chatBoxName);
    await Hive.openBox<dynamic>(feedBoxName);
  }

  static Box<dynamic> authBox() {
    return Hive.box<dynamic>(authBoxName);
  }

  static Box<dynamic> chatBox() {
    return Hive.box<dynamic>(chatBoxName);
  }

  static Box<dynamic> feedBox() {
    return Hive.box<dynamic>(feedBoxName);
  }
}
