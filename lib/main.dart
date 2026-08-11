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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  child: const Column(children: [
                    Text('⭐'),
                    Text('0'),
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
                  child: const Column(children: [
                    Text('♻️'),
                    Text('0'),
                    Text('Items'),
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
                  child: const Column(children: [
                    Text('🔥'),
                    Text('0'),
                    Text('Streak'),
                  ],),
                ),
              ),
            ],
          ),
        const SizedBox(height:30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecylingPage()),
            );
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

class RecylingPage extends StatelessWidget {
  const RecylingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Something'),
      ),
      body: Padding(
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
                print(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}