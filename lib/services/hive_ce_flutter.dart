import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:recycle_app/models/recycling_activity.dart';

class ActivityService{
  static Box<RecyclingActivity> get _box =>
    Hive.box<RecyclingActivity>('activities');

  static Future<void> addActivity(RecyclingActivity activity) async{
    await _box.add(activity);
  }

  static List<RecyclingActivity> getAllActivities(){
    return _box.values.toList();
  }

  static Future<void> deleteActivity(RecyclingActivity activity) async{
    await activity.delete();
  }

  static Stream<BoxEvent> watchActivities(){
    return _box.watch();
  }

}