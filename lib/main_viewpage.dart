import 'package:flutter/material.dart';
import 'screen/main_screen.dart';
import 'screen/schedule_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageView(),
    );
  }
}

class MainPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('左右滑動頁面'),
      ),*/
      body: PageView(
        children: [
          MainScreen(),
          ScheduleScreen(),
        ],
      ),
    );
  }
}
