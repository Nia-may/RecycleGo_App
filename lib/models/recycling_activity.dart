import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

part 'recycling_activity.g.dart';

@HiveType(typeId: 0)
class RecyclingActivity extends HiveObject{
  @HiveField(0) String item;
  @HiveField(1) int quantity;
  @HiveField(2) int points;
  @HiveField(3) DateTime dateTime;
  @HiveField(4) String? photoPath;
  @HiveField(5) String id;

  RecyclingActivity({
    required this.item,
    required this.quantity,
    required this.points,
    required this.dateTime,
    this.photoPath,
    String? id, 
  }) : id = id ?? const Uuid().v4();
}