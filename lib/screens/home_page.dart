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
  int _selectedIndex=0;
  DateTime? lastRecyclingDate;

  User? get currentUser{
    return Supabase.instance.client.auth.currentUser;
  }

  late int weeklyGoal;
@override
void initState() {
  super.initState();
  weeklyGoal = widget.weeklyGoal;

  loadHomeData();
}

Future<void> loadHomeData() async {
  await loadData();
  loadActivities();
  await recalculateStats();
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
    streak=calculatedStreak;
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

  savedActivities.sort(
    (a,b) => b.dateTime.compareTo(a.dateTime),
  );

  if(!mounted) return;

  setState(() {
    recentActivities=savedActivities;
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.softGreen,
              backgroundImage: const AssetImage('lib/assets/earth.png'),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${currentUser?.userMetadata?['full_name']?? 'there'}',
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                Text(
                  "Let's contribute to our Earth",
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
                'Your Progress',
                 style: GoogleFonts.gochiHand(
                 fontSize: 21,
                 fontWeight: FontWeight.bold,
                 color: Theme.of(context).colorScheme.onSurface,
                ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.softGreen.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.softGreen,
                      width: 1,
                    ),
                  ),
                  child: Column(children: [
                    Image.asset(
                      'lib/assets/starTrans.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 6),
                    
                    Text('$totalPoints',
                    style: GoogleFonts.schoolbell(
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
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.softGreen.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.softGreen,
                      width: 1,
                    ),
                  ),
                  child: Column(children: [
                    Image.asset(
                      'lib/assets/DogBin.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 6),

                    Text('$totalItems',
                    style: GoogleFonts.schoolbell(
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
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.softGreen.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.softGreen,
                      width: 1,
                    ),
                  ),
                  child: Column(children: [
                    Image.asset(
                      'lib/assets/streakTrans.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 6),
                    
                    Text('$streak', style: GoogleFonts.schoolbell(
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

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.softGreen.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.softGreen,
                      width: 1,
                    ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               const SizedBox(height: 10),

              LayoutBuilder(
                builder: (context, constraints){
                  final progress = weeklyGoal == 0
                    ? 0.0
                    : (weeklyItems/weeklyGoal).clamp(0.0, 1.0);

                  // ignore: unnecessary_nullable_for_final_variable_declarations
                  const double iconSize= 24;
                  
                  final iconPosition=
                    progress * (constraints.maxWidth - iconSize);

                  return SizedBox(
                    height: 28,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        Positioned(left: iconPosition,
                        top: 2,
                        child: Image.asset('lib/assets/catEarth.png', width: iconSize, height: iconSize,
                        ),
                        ),
                      ],
                    ),
                  );
                },),

                const SizedBox(height: 8),
                Center(
                child: Text('You have recycled $weeklyItems out of $weeklyGoal items this week!', 
                style: GoogleFonts.handlee(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.softGreen.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.softGreen,
                      width: 1,
                    ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.gochiHand(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

               const SizedBox(height: 12),

             if (recentActivities.isEmpty)
                const Text('No recent activity.')
            else
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Picture on the left
                  Image.asset(
                    'lib/assets/recycleBin.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 14),

                  // Existing activity information on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: displayedActivities.map((activity) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  children: [
                                    Image.asset(
                                      'lib/assets/recycleIcon.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${activity.item} × ${activity.quantity}',
                                    ),
                                  ],
                                ),
                              Text(
                                '+${activity.points} points',
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        ],
        ),
      ),

bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,

  onTap: (index) async {
    setState(() {
      _selectedIndex = index;
    });

    // ♻️ Recycle
    if (index == 1) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecylingPage(),
        ),
      );

      if (result != null && result is Map) {
        final points = result['points'] as int;
        final items = result['items'] as int;

        final activity = RecyclingActivity(
          item: result['item'] as String,
          quantity: items,
          points: points,
          dateTime: DateTime.now(),
          photoPath: result['photoPath'] as String?,
        );

        await ActivityService.addActivity(activity);

        if (Supabase.instance.client.auth.currentUser != null) {
          await SupabaseActivity.uploadActivity(activity);
        }

        if (!mounted) return;

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

      if (mounted) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    }

    // 📋 Activity
    if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ActivityPage(),
        ),
      );

      if (mounted) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    }

    // 👤 Profile
    if (index == 3) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            weeklyGoal: weeklyGoal,
            onDarkModeChanged: widget.onDarkModeChanged,
          ),
        ),
      );

      if (!mounted) return;

      // Get the new goal returned from ProfilePage
      if (result != null && result is int) {
        setState(() {
          weeklyGoal = result;
        });
      }

      await recalculateStats();
      loadActivities();

      if (mounted) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    }
  },

  type: BottomNavigationBarType.fixed,

  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'lib/assets/recycleIcon.png',
        width: 28,
        height: 28,
      ),
      label: 'Recycle',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      activeIcon: Icon(Icons.history),
      label: 'Activity',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
),
    );
  }
}