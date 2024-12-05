import 'package:flutter/material.dart';
import '../tool/clandar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SizedBox(
                width: 500, // 根據需要調整大小
                height: 700,
                child: CalendarPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
