import 'package:hive_ce/hive.dart';
import 'package:recycle_app/models/recycling_activity.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(RecyclingActivityAdapter());
  }
}
