import 'package:flutter/material.dart';

import 'services/storage_service.dart';
import 'theme/app_theme.dart';

import 'screens/startup_page.dart';

void main() {
  runApp(const RecycleGoApp());
}

class RecycleGoApp extends StatefulWidget {
  const RecycleGoApp({super.key});

  @override
  State<RecycleGoApp> createState()=> _RecycleGoAppState(); //_ means private
  // This widget is the root of your application.
}

class _RecycleGoAppState extends State<RecycleGoApp>{
  bool isDarkMode =false;

  @override
  void initState(){
    super.initState();
    loadDarkMode();
  }

  Future<void> loadDarkMode() async {
    final savedDarkMode = await StorageService.getDrkMode();

    if (mounted){
      setState(() {
        isDarkMode = savedDarkMode;
      });
    }
  }

  void changeDarkMode(bool value){
    setState(() {
      isDarkMode=value;
    });

    StorageService.saveDarkMode(value);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleGo',

      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: isDarkMode? ThemeMode.dark: ThemeMode.light,
      home: StartupPage(isDarkMode: isDarkMode, onDarkModeChanged: changeDarkMode,),
    );
  }
}
