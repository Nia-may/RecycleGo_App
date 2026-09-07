import 'package:recycle_app/services/hive_ce_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/recycling_activity.dart';

class SupabaseActivity{
  static final _supabase = Supabase.instance.client;

  static Future<void> uploadActivity(
    RecyclingActivity activity,
  )async{
    final user = _supabase.auth.currentUser;

    if (user == null){
      throw Exception('User is not logged in');
    }

    await _supabase.from('activities').insert({
      'user_id':user.id,
      'item':activity.item,
      'quantity': activity.quantity,
      'points': activity.points,
      'date_time': activity.dateTime.toIso8601String(),
      'photo_path': activity.photoPath,
    });
  }

  static Future<List<RecyclingActivity>> getCloudActivities() async {
    final user =_supabase.auth.currentUser;

    if (user == null){
      return [];
    }

    final response = await _supabase
      .from('activities')
      .select()
      .eq('user_id', user.id)
      .order('date_time', ascending: false);

    return (response as List).map((data){
      return RecyclingActivity(
        item: data['item'], 
        quantity: data['quantity'], 
        points: data['points'], 
        dateTime: DateTime.parse(data['date_time']),
        photoPath: data['photo_path'],
        );
    }).toList();
  }

  static Future<void> restoreActivitiesToHive() async {
    final cloudActivities = await getCloudActivities();

    final localActivities = ActivityService.getAllActivities();

    for (final cloudActivity in cloudActivities){
      final alreadyExists=localActivities.any(
        (localActivity) =>
          localActivity.item == cloudActivity.item &&
          localActivity.quantity == cloudActivity.quantity &&
          localActivity.points == cloudActivity.points &&
          localActivity.dateTime
                    .difference(cloudActivity.dateTime)
                    .abs()
                    .inSeconds<
                    2,
      );

      if (!alreadyExists){
        await ActivityService.addActivity(cloudActivity);
      }
    }
  }

  static Future<void> removeDuplicateActivities() async{
    final activities=ActivityService.getAllActivities();

    final seen=<String>{};

    for (final activity in activities){
      final key=
        '${activity.item}_${activity.quantity}_${activity.points}_${activity.dateTime.toIso8601String().substring(0,19)}';

      if(seen.contains(key)){
        await ActivityService.deleteActivity(activity);
      }else{
        seen.add(key);
      }
    }
  }
}