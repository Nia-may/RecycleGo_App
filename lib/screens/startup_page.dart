import 'package:flutter/material.dart';

import 'home_page.dart';
import 'weekly_goal_page.dart';
import '/services/storage_service.dart';

class StartupPage extends StatefulWidget{
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const StartupPage({super.key, required this.isDarkMode, required this.onDarkModeChanged});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage>{
  @override
  void initState(){
    super.initState();
    checkWeeklyGoal();
  }

  Future<void> checkWeeklyGoal() async {
    final savedGoal = await StorageService.getWeeklyGoal();

    if(!mounted) return;

    if (savedGoal == null){
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => WeeklyGoalPage(isDarkMode: widget.isDarkMode,
      onDarkModeChanged: widget.onDarkModeChanged,),),);
    } else {
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => HomePage(weeklyGoal: savedGoal, isDarkMode: widget.isDarkMode,
      onDarkModeChanged: widget.onDarkModeChanged,),),);
    }
  }

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}