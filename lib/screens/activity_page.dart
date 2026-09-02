import 'package:flutter/material.dart';
import 'dart:io';
import '/models/recycling_activity.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  String formatDate(DateTime date){
    final now = DateTime.now();

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } 

    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
      ),
      body: ValueListenableBuilder(valueListenable: Hive.box<RecyclingActivity>('activities').listenable(), 
      builder: (context, Box<RecyclingActivity> box, _){
        final activities = box.values.toList().reversed.toList();
        if(activities.isEmpty){
          return const Center(child: Text('No activities to display'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final DateTime dateTime = activity.dateTime;
                

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activity.photoPath != null) 
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(activity.photoPath!),
                                height: 200,
                                width:double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),

                  Text('♻️ ${activity.item} × ${activity.quantity}',
                  style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('+${activity.points} pts',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),

                  const SizedBox(height: 6),


                  Text(
                    '${formatDate(dateTime)} • ${formatTime(dateTime)}',
                    style: const TextStyle(color: Colors.grey),
                 ),
                    ],
                  ),
                ),
              ); // closes Card
            },
          ); // closes ListView.builder
        },
      ), // closes ValueListenableBuilder
    );
  }
}