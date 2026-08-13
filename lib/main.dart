import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalPoints = 0;
  int totalItems = 0;
  int streak=0;
  DateTime? lastRecyclingDate;

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 138, 231, 161),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 202, 57),
        title: const Text('RecycleGo'),
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

                const Text('♻️ Plastic Bottle × 5'),
                const Text('+25 points'),
            ],
          ),
        ),
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
                onPressed: () {
                  print('Choose photo');
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Upload Photo'),
              ),

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