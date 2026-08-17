import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF8FD694);
  static const background = Color(0xFFF3FAF4);
  static const white = Color(0xFFFFFFFF);

  static const softBlue = Color(0xFFDCEFF2);
  static const softYellow = Color(0xFFFFF3C4);
  static const softPeach = Color(0xFFFFE4D6);

  static const text=Color(0xFF3F5143);
}

void main() {
  runApp(const RecycleGoApp());
}

class RecycleGoApp extends StatelessWidget {
  const RecycleGoApp({super.key});
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleGo',

      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,

        textTheme: GoogleFonts.nunitoTextTheme(),

        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary,),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.fredoka(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor:AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const WeeklyGoalPage(),
    );
  }
}

class RecyclingActivity {
  final String item;
  final int quantity;
  final int points;
  final DateTime dateTime;
  final String? photoPath;

  RecyclingActivity({
    required this.item,
    required this.quantity,
    required this.points,
    required this.dateTime,
    this.photoPath,
  });
}

class WeeklyGoalPage extends StatefulWidget{
  const WeeklyGoalPage({super.key});

  @override
  State<WeeklyGoalPage> createState() => _WeeklyGoalPageState();
}

class _WeeklyGoalPageState extends State<WeeklyGoalPage>{
  final TextEditingController goalController=TextEditingController();

  @override
  void dispose(){
    goalController.dispose();
    super.dispose();
  }

  void saveGoal(){
    final goal=int.tryParse(goalController.text);

    if (goal==null||goal<=0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid goal.'),),
      );
      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: 
    (context)=> HomePage(weeklyGoal: goal),),);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '♻️',
            style: TextStyle(fontSize: 60),),

            const SizedBox(height: 20),

            Text(
              'Set Your Weekly Goal',
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              'How many items would u like to recycle each week?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weekly goal',
                hintText: 'e.g. 10',
                border: OutlineInputBorder(),
              ),),
              
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveGoal,
                  child: const Text('continue'),
                ),
              ),
        ],
      ),),
    );
  }
}

class HomePage extends StatefulWidget {
  final int weeklyGoal;

  const HomePage({
    super.key,
    required this.weeklyGoal,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class ActivityPage extends StatelessWidget {
  final List<RecyclingActivity> activities;

  const ActivityPage({super.key, required this.activities});

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
      body: activities.isEmpty
          ? const Center(child: Text('No activities to display'))
          : ListView.builder(
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
                      color: Colors.green.shade100,
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
          );
        },
      ),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    final displayedActivities = recentActivities.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('RecycleGo',
        style: GoogleFonts.fredoka(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        )),
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
                color: AppColors.text,
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
                    color: Colors.green.shade50,
                  ),
                  child: Column(children: [
                    Text('⭐',
                    style: TextStyle(fontSize: 24),),

                    const SizedBox(height: 6),
                    
                    Text('$totalPoints',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),),
                    Text('Points',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.text,
                    ),),
                  ],),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.shade50,
                  ),
                  child: Column(children: [
                    const Text('♻️', style: TextStyle(fontSize: 24,),),

                    const SizedBox(height: 6),

                    Text('$totalItems',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),),
                    Text('Items', style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.text,
                    ),),
                  ],),
                ),
              ),
              
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.shade50,
                  ),
                  child: Column(children: [
                    const Text('🔥', style: TextStyle(fontSize: 24),),

                    const SizedBox(height: 6),
                    
                    Text('$streak', style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),),
                    Text('Streak',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.text,
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
              setState(() {
                totalPoints += result['points'] as int;
                totalItems += result['items'] as int;
                weeklyItems += result['items'] as int;

                recentActivities.insert(0, RecyclingActivity(
                  item: result['item'] as String,
                  quantity: result['items'] as int,
                  points: result['points'] as int,
                  dateTime: DateTime.now(),
                  photoPath: result['photoPath'] as String?,
                ));

                updateStreak();
              });
            }
          },
          child: const Text('Recycle something'),
        ),

        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.green.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                 style: GoogleFonts.fredoka(
                 fontSize: 21,
                 fontWeight: FontWeight.bold,
                 color: AppColors.text,
                ),
              ),

               const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: weeklyGoal == 0 ? 0 
                      :(weeklyItems/weeklyGoal).clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: AppColors.softBlue,
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
            color: Colors.blue.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.fredoka(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
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
        const SizedBox(height: 20),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActivityPage(activities: recentActivities,),),
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

class RecylingPage extends StatefulWidget {
  const RecylingPage({super.key});

  @override
  State<RecylingPage> createState() => _RecylingPageState();
}

class _RecylingPageState extends State<RecylingPage> {
  final ImagePicker picker = ImagePicker(); 
  XFile? selectedImage;
  String? selectedItem;

  int calculatePoints(){
    int pointsPerItem = 0;

  if (selectedItem == 'Plastic'){
    pointsPerItem = 5;
  }else if (selectedItem == 'Paper'){
    pointsPerItem = 2;
  }else if (selectedItem == 'Glass'){
    pointsPerItem = 4;
  }else if (selectedItem == 'Metal'){
    pointsPerItem = 8;
  }

  int quantity = int.tryParse(quantityController.text) ?? 0;
  return pointsPerItem * quantity;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Something'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are you recycling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Select an item',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Recycling Item',
              ),
              items: const [
                DropdownMenuItem(value: 'Plastic', child: Text('Plastic'),),
                DropdownMenuItem(value: 'Paper', child: Text('Paper'),),
                DropdownMenuItem(value: 'Glass', child: Text('Glass'),),
                DropdownMenuItem(value: 'Metal', child: Text('Metal'),),
              ],
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
            ),
             const SizedBox(height: 20),

             const Text(
              'How many?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
             ),

             const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
                hintText: 'e.g. 2',),
              controller: quantityController,
            ),

              const SizedBox(height: 30),

              const Text(
                'Photo',
                style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: () => pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
              ),//take photo by camera
              OutlinedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text('Choose from Gallery'),
              ),//take photo from gallery


              if (selectedImage != null) ...[
                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                Image.file(
                  File(selectedImage!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedItem == null || quantityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an item and enter a quantity.')),
                      );
                      return;
                    }
                    int points=calculatePoints();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('♻️ Recycling Submitted!'),
                          content: Text('You have recycled ${quantityController.text} ${selectedItem!.toLowerCase()} item(s).\n\n'
                          '🎉 You earned $points points!',),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context, {
                                  'points': points,
                                  'items': int.tryParse(quantityController.text) ?? 0,
                                  'item': selectedItem,
                                  'photoPath': selectedImage?.path,
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    );
                  },
                  child: const Text('Submit Recycling'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}