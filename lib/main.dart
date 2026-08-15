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
      home: const HomePage(),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Nin',
               style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
         ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green.shade50,
                  ),
                  child: Column(children: [
                    Text('⭐'),
                    Text('$totalPoints'),
                    Text('Points'),
                  ],),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade50,
                  ),
                  child: Column(children: [
                    const Text('♻️'),
                    Text('$totalItems'),
                    const Text('Items'),
                  ],),
                ),
              ),
              
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.shade50,
                  ),
                  child: Column(children: [
                    const Text('🔥'),
                    Text('$streak'),
                    const Text('Streak'),
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
              const Text(
                'Your Progress',
                 style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
                ),
              ),

               const SizedBox(height: 10),

                LinearProgressIndicator(
                value: 0.5,
                minHeight: 10,
                ),

                const SizedBox(height: 8),

                const Text('You have recycled 5 out of 10 items this week!',
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
              const Text(
                'Recent Activity',
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
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