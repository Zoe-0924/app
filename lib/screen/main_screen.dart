import 'package:flutter/material.dart';
import '../tool/clock.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('每日任務'),centerTitle: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 上方顯示每日要完成的事情
            /*Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '今天要完成的事：\n1. 讀微積分 2 小時',
                style: TextStyle(fontSize: 18),
              ),
            ),*/
            SizedBox(height: 10),
            // 中間的文字方塊：今日要事
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '今日要事',
                  border: InputBorder.none,
                ),
              ),
            ),
           Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 400, // 根據需要調整大小
                height: 400,
                child: TaskAnalogClock(),
              )
            ),
            SizedBox(height: 10),
            // 下方分左右兩部分
            Row(
              children: <Widget>[
                // 左邊：一周狀況
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('一周狀況：'),
                        Text('睡眠狀況：良好'),
                        Text('讀書狀況：未達目標'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // 右邊：為自己制定的目標
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('為自己設定的目標：'),
                        Text('每天讀書 3 小時'),
                        Text('每天運動 1 小時'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 最底部左右兩個按鈕
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // 行程按鈕的操作
                  },
                  child: Text('行程'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 設置按鈕的操作
                  },
                  child: Text('設置'),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
