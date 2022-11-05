import 'package:flutter/material.dart';
import 'package:lab_1/constants/app_styles.dart';
import 'package:lab_1/screens/lab1_screen.dart';
import 'package:lab_1/screens/lab2_screen.dart';
import 'package:lab_1/screens/lab4_screen.dart';

import 'lab3_screen.dart';

class MainScreen extends StatelessWidget {
  static const String path = "home";

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Lab1Screen.path);
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Лабораторна 1",
                    style: AppStyles.titleText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Lab2Screen.path);
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Лабораторна 2",
                    style: AppStyles.titleText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Lab3Screen.path);
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Лабораторна 3",
                    style: AppStyles.titleText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Lab4Screen.path);
                },
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Лабораторна 4",
                    style: AppStyles.titleText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {},
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Лабораторна 5",
                    style: AppStyles.titleText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
