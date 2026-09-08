import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_app/services/hive_ce_flutter.dart';
import '/services/storage_service.dart';
import 'profile_page.dart';
import 'recycling_page.dart';
import 'activity_page.dart';
import '/theme/app_theme.dart';
import '/models/recycling_activity.dart';
import 'package:recycle_app/services/supabase_activity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final int weeklyGoal;
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const HomePage({
    super.key,
    required this.weeklyGoal,
    required this.isDarkMode,
    required this.onDarkModeChanged,

  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalPoints = 0;
  int totalItems = 0;
  int streak=0;
  DateTime? lastRecyclingDate;

  late int weeklyGoal;
  @override
  void initState(){
    super.initState();
    weeklyGoal=widget.weeklyGoal;

    loadData();
    loadActivities();
    recalculateStats();
  }

Future<void> recalculateStats() async {
  final activities = ActivityService.getAllActivities();

  int points = 0;
  int items = 0;
  int weekly = 0;

  for (final activity in activities){
    points += activity.points;
    items += activity.quantity;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    if (activity.dateTime.isAfter(
      DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      ),
    )) {
      weekly +=activity.quantity;
    }
  }

  if (!mounted) return;

  final calculatedStreak=calculateStreak(activities);

  setState(() {
    totalPoints = points;
    totalItems = items;
    weeklyItems =  weekly;
  });
}

Future<void> loadData() async {
  final savedPoints=await StorageService.getPoints();
  final savedItems=await StorageService.getItems();
  final savedStreak=await StorageService.getStreak();
  final savedWeeklyItems=await StorageService.getWeeklyItems();
  final savedLastDate=await StorageService.getRecyclingDate();

  if (!mounted) return;
    setState((){
      totalPoints=savedPoints;
      totalItems=savedItems;
      streak=savedStreak;
      weeklyItems=savedWeeklyItems;
      lastRecyclingDate=savedLastDate;
    });
}

void loadActivities(){
  final savedActivities=ActivityService.getAllActivities();

  if(!mounted) return;

  setState(() {
    recentActivities=savedActivities.reversed.toList();
  });
}

  int weeklyItems=0;

  List<RecyclingActivity> recentActivities = [];

  void updateStreak() {
    final today = DateTime.now();
    if (lastRecyclingDate == null) {
      streak=1;
    }else{
      final difference = today.difference(lastRecyclingDate!).inDays;

      if (difference == 1) {
        streak++;
      } else if (difference > 1) {
        streak = 1; // Reset streak if more than a day has passed
      }
    }
    lastRecyclingDate = today;
  }

int calculateStreak(List<RecyclingActivity> activities){
  if (activities.isEmpty){
    return 0;
  }

  final dates = activities
    .map((activity) => DateTime(
      activity.dateTime.year,
      activity.dateTime.month,
      activity.dateTime.day,
    ))
    .toSet()
    .toList();

  dates.sort((a,b) => b.compareTo(a));

  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);

  if (dates.first != todayDate){
    return 0;
  }

  int currentStreak =1;

  for (int i = 1; i<dates.length;i++){
    final difference = dates[i-1].difference(dates[i]).inDays;

    if(difference == 1){
      currentStreak++;
    }else{
      break;
    }
  }

  return currentStreak;
}

  @override
  Widget build(BuildContext context) {
    final displayedActivities = recentActivities.take(3).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('RecycleGo'),

        actions: [
          IconButton(
            onPressed: () async{
              final result = await Navigator.push (
                context,
                MaterialPageRoute(builder: (context)=>ProfilePage(weeklyGoal: weeklyGoal, 
                onDarkModeChanged: widget.onDarkModeChanged,
               ),),
              );

              if (mounted){
                await recalculateStats();
                loadActivities();
              }

              if (result != null && result is int && mounted){
                setState(() {
                  weeklyGoal=result;
                });
              }
            },
            icon: const Icon(
              Icons.account_circle
            ),
          ),
          const SizedBox(width: 8),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Nin',
               style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
         ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(children: [
                    Text('⭐',
                    style: TextStyle(fontSize: 24),),

                    const SizedBox(height: 6),
                    
                    Text('$totalPoints',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                    Text('Points',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                  ],),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(children: [
                    const Text('♻️', style: TextStyle(fontSize: 24,),),

                    const SizedBox(height: 6),

                    Text('$totalItems',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                    Text('Items', style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                  ],),
                ),
              ),
              
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(children: [
                    const Text('🔥', style: TextStyle(fontSize: 24),),

                    const SizedBox(height: 6),
                    
                    Text('$streak', style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                    Text('Streak',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),),
                  ],),
                ),
              ),
            ],
          ),
        const SizedBox(height:30),
        ElevatedButton(
          onPressed: () async{
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecylingPage()),
            );

            if (result != null && result is Map) {

              final points = result['points'] as int;
              final items = result['items'] as int;

              final activity=RecyclingActivity(
                item: result['item'] as String, 
                quantity: items, 
                points: points, 
                dateTime: DateTime.now(),
                photoPath: result['photoPath'] as String?,);

                await ActivityService.addActivity(activity);

                if (Supabase.instance.client.auth.currentUser != null){
                  await SupabaseActivity.uploadActivity(activity);
                }

              setState(() {
                totalPoints += points;
                totalItems += items;
                weeklyItems += items;

                recentActivities.insert(0, activity);

                updateStreak();
              });

              await StorageService.savePoints(totalPoints);
              await StorageService.saveItems(totalItems);
              await StorageService.saveWeeklyItems(weeklyItems);
              await StorageService.saveStreak(streak);

              if (lastRecyclingDate != null) {
                await StorageService.saveRecyclingDate(lastRecyclingDate!);
              }
            }
          },
          child: const Text('Recycle something'),
        ),

        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                 style: GoogleFonts.fredoka(
                 fontSize: 21,
                 fontWeight: FontWeight.bold,
                 color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

               const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: weeklyGoal == 0 ? 0 
                      :(weeklyItems/weeklyGoal).clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),),
                ),

                const SizedBox(height: 8),

                Text('You have recycled $weeklyItems out of $weeklyGoal items this week!',
        ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.fredoka(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

               const SizedBox(height: 12),

              if (recentActivities.isEmpty)
                const Text('No recent activity.')
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedActivities.map((activity) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            '♻️ ${activity.item} × ${activity.quantity}',
                          ),
                          Text('+${activity.points} points'),
                        ],
                      ),
                    );
                  }).toList(),
                )
            ],
          ),
        ),
        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityPage(),),
              );
            },
            child: const Text('View Activity History'),
          ),
        )
        ],
        ),
      ),
    );
  }
}