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
      appBar: AppBar(
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
        ],
        ),
      ),
    );
  }
}
