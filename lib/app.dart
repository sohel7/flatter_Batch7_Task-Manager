import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/splash_screen.dart';
import 'package:task_manager_project/ui/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme:ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          hintStyle: TextStyle(color: Colors.grey)
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
      //  primaryColor: AppColor.themeColor,
        colorSchemeSeed: AppColor.themeColor,
       // primarySwatch: AppColor.themeColor,
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      home: const SplashScreen(),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData(){
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          backgroundColor: AppColor.themeColor,
          foregroundColor: Colors.white,
          padding:  const EdgeInsets.symmetric( horizontal: 12, vertical: 10),
          fixedSize: Size.fromWidth(double.maxFinite)
        )
    );
  }
}
