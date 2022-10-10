import 'package:flutter/material.dart';
import 'package:lab_1/screens/lab1_screen.dart';
import 'package:lab_1/screens/lab2_screen.dart';
import 'package:lab_1/screens/lab3_screen.dart';
import 'package:lab_1/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.path,
      routes: {
        MainScreen.path: (context) => const MainScreen(),
        Lab1Screen.path: (context) => const Lab1Screen(
              variantNum: 21,
            ),
        Lab2Screen.path: (context) => const Lab2Screen(),
        Lab3Screen.path: (context) => const Lab3Screen(),
      },
    );
  }
}
