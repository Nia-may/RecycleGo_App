import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '/services/storage_service.dart';
import '/theme/app_theme.dart';
import 'home_page.dart';


class WeeklyGoalPage extends StatefulWidget{
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const WeeklyGoalPage({super.key, required this.isDarkMode, required this.onDarkModeChanged});

  @override
  State<WeeklyGoalPage> createState() => _WeeklyGoalPageState();
}

class _WeeklyGoalPageState extends State<WeeklyGoalPage>{
  final TextEditingController goalController=TextEditingController();

  

  Future<void> saveGoal() async {
    final goal=int.tryParse(goalController.text);

    if (goal==null||goal<=0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid goal.'),),
      );
      return;
    }

    await StorageService.saveWeeklyGoal(goal);

    if (!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: 
    (context)=> HomePage(weeklyGoal: goal,isDarkMode: widget.isDarkMode, onDarkModeChanged: widget.onDarkModeChanged,),),);
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