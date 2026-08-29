import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _darkModeKey = 'darkMode';
  static const String _itemsKey='items';
  static const String _pointsKey='points';
  static const String _streakKey='streak';
  static const String _weeklyGoalKey = 'weeklyGoal';
  static const String _weeklyItemsKey = 'weeklyItems';
  static const String _lastRecyclingDateKey = 'lastRecylingDate';

static Future<void> saveDarkMode(bool dark) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setBool(StorageService._darkModeKey, dark);
}

static Future<bool> getDrkMode() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getBool(_darkModeKey)?? false;
}

static Future<void> saveItems(int items) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setInt(StorageService._itemsKey, items);
}

static Future<int> getItems() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getInt(_itemsKey)??0;
}

static Future<void> savePoints(int points) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setInt(StorageService._pointsKey, points);
}

static Future<int> getPoints() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getInt(_pointsKey)??0;
}

static Future<void> saveStreak(int streak) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setInt(StorageService._streakKey, streak);
}

static Future<int> getStreak() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getInt(_streakKey)??0;
}

static Future<void> saveWeeklyGoal(int goal) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setInt(StorageService._weeklyGoalKey, goal);
}
//int? means can have number or null
//int means must have number
static Future<int?> getWeeklyGoal() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getInt(_weeklyGoalKey);
}

static Future<void> saveWeeklyItems(int items) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setInt(StorageService._weeklyItemsKey, items);
}

static Future<int> getWeeklyItems() async {
  final prefs=await SharedPreferences.getInstance();
  return prefs.getInt(_weeklyItemsKey)??0;
}

static Future<void> saveRecyclingDate(DateTime date) async {
  final prefs=await SharedPreferences.getInstance();
  await prefs.setString(StorageService._lastRecyclingDateKey, date.toIso8601String());
}

static Future<DateTime?> getRecyclingDate() async {
  final prefs=await SharedPreferences.getInstance();
  final dateString = prefs.getString(_lastRecyclingDateKey);

  if (dateString == null){
    return null;
  }

  return DateTime.tryParse(dateString);
}
}