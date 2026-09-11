import 'package:recycle_app/services/hive_ce_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/recycling_activity.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SupabaseActivity{
  static final _supabase = Supabase.instance.client;

  static Future<void> uploadActivity(
  RecyclingActivity activity,
) async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  String? remotePhotoPath;

  // Handle photo
  if (activity.photoPath != null) {
    final file = File(activity.photoPath!);

    print('PHOTO PATH: ${activity.photoPath}');
    print('PHOTO EXISTS: ${await file.exists()}');

    if (await file.exists()) {
      final extension = activity.photoPath!.split('.').last;
      final storagePath = '${user.id}/${activity.id}.$extension';

      try {
        print('STARTING PHOTO UPLOAD: $storagePath');

        await _supabase.storage
            .from('recycling-photos')
            .upload(
              storagePath,
              file,
              fileOptions: const FileOptions(
                upsert: false,
              ),
            );

        remotePhotoPath = storagePath;

        print('PHOTO UPLOAD SUCCESS');
      } catch (e) {
        print('PHOTO UPLOAD FAILED: $e');

        // Don't stop the database upload if the photo fails
        remotePhotoPath = null;
      }
    } else {
      print('PHOTO FILE DOES NOT EXIST');
    }
  }

  // Save activity to database
  try {
    print('STARTING DATABASE INSERT');

    await _supabase.from('activities').insert({
      'id': activity.id,
      'user_id': user.id,
      'item': activity.item,
      'quantity': activity.quantity,
      'points': activity.points,
      'date_time': activity.dateTime.toIso8601String(),
      'photo_path': remotePhotoPath,
    });

    print('DATABASE INSERT SUCCESS');
  } catch (e) {
    print('DATABASE INSERT FAILED: $e');
    rethrow;
  }
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
        id: data['id'],
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

    final directory = await getApplicationDocumentsDirectory();

    for (final cloudActivity in cloudActivities){
      final alreadyExists=localActivities.any(
        (localActivity) => localActivity.id == cloudActivity.id,
      );

      if (!alreadyExists){
        String? localPhotoPath = cloudActivity.photoPath;

        if(cloudActivity.photoPath != null){
          final storagePath = cloudActivity.photoPath!;
          final fileName= storagePath.split('/').last;

          final localFile=File(
            '${directory.path}/$fileName',
          );

          try {
            final photoBytes = await _supabase.storage
              .from('recycling-photos')
              .download(storagePath);

            await localFile.writeAsBytes(photoBytes);

            localPhotoPath = localFile.path;
          }catch (e){
            print('Failed to download photo: $e');
            localPhotoPath = null;
          }
        }

        final restoredActivity = RecyclingActivity(
          id: cloudActivity.id,
          item: cloudActivity.item,
          quantity: cloudActivity.quantity,
          points: cloudActivity.points,
          dateTime: cloudActivity.dateTime,
          photoPath: localPhotoPath,
        );

        await ActivityService.addActivity(restoredActivity);
      }
    }
  }
}