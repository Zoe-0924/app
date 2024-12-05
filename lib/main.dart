import 'package:flutter/material.dart';
//import 'form_screen.dart';
import 'main_viewpage.dart';
import 'form/weekly_plan_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 首頁
      routes: {
        '/': (context) => AppEntry(), // 入口頁面
        '/form': (context) => WeeklyPlanForm(), // 表單頁面
        '/main': (context) => MainPageView(), // 主頁面
      },
    );
  }
}

class AppEntry extends StatefulWidget {
  @override
  _AppEntryState createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _isFormCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkFormCompletion();
  }

  void _checkFormCompletion() async {
    // 模擬從本地檢查狀態
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isFormCompleted = false; // 修改為 true 測試直接跳主畫面
    });

    // 根據檢查結果跳轉
    if (_isFormCompleted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // 載入畫面
    );
  }
}
