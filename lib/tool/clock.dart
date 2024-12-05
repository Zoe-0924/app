import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Analog Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskAnalogClock(),
    );
  }
}

class TaskAnalogClock extends StatefulWidget {
  @override
  _TaskAnalogClockState createState() => _TaskAnalogClockState();
}

class _TaskAnalogClockState extends State<TaskAnalogClock> {
  DateTime currentTime = DateTime.now();
  bool showText = false; // 控制文本顯示的變數
  Timer? _timer; 

  
  @override
  void initState() {
    super.initState();
    // 初始化計時器
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateTime.now();
        });
      }
    });
  }

   @override
  void dispose() {
    // 取消計時器
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Task Analog Clock')),
      body: Center(
        child: GestureDetector(
          onTapDown: (_) {
            // 偵測點擊開始
            setState(() {
              showText = true; // 點擊時顯示文本
            });
          },
          onTapUp: (_) {
            // 偵測點擊結束
            setState(() {
              showText = false; // 點擊結束時隱藏文本
            });
          },
          onLongPressStart: (_) {
            // 偵測長按開始
            setState(() {
              showText = true; // 長按時顯示文本
            });
          },
          onLongPressEnd: (_) {
            // 偵測長按結束
            setState(() {
              showText = false; // 長按結束時隱藏文本
            });
          },
          child: Container(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: TaskClockPainter(currentTime, showText),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskClockPainter extends CustomPainter {
  final DateTime dateTime;
  final bool showText;

  TaskClockPainter(this.dateTime, this.showText);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    // 畫外圈
    Paint circlePaint = Paint()..color = const Color.fromARGB(255, 253, 253, 253);
    canvas.drawCircle(center, radius, circlePaint);

    // 畫數字 1~12
    Paint numberPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 1; i <= 12; i++) {
      String number = i.toString();
      textPainter.text = TextSpan(  
        text: number,
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      );
      textPainter.layout();

      double angle = (i * pi / 6) - pi / 2; // 計算每個數字的位置角度
      double x = centerX + (radius - 30) * cos(angle); // 數字的 x 座標
      double y = centerY + (radius - 30) * sin(angle); // 數字的 y 座標

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // 畫每分鐘的格子
    Paint minuteGridPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    for (int i = 0; i < 60; i++) {
      double angle = (i * 2 * pi / 60) - pi / 2; // 計算每個格子的位置角度
      double x1 = centerX + (radius - 10) * cos(angle); // 起點
      double y1 = centerY + (radius - 10) * sin(angle); // 起點
      double x2 = centerX + radius * cos(angle); // 終點
      double y2 = centerY + radius * sin(angle); // 終點

      // 畫每個格子（小刻度）
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), minuteGridPaint);
    }

    // 畫任務時間區間 (例如：2:00 到 3:00)，填充圓心到邊緣的區域
    Paint taskArcPaint = Paint()
      ..color = const Color.fromARGB(255, 238, 165, 8)
      ..style = PaintingStyle.fill; // 使用填充樣式來畫扇形

    double startAngle = 2 * pi / 12 * 2 - pi / 2; // 2:00 的角度
    double sweepAngle = 2 * pi / 12; // 1 小時的弧度

    // 調整扇形半徑，使它不會蓋到數字
    double taskArcRadius = radius - 40; // 調整半徑，避免蓋到數字

    // 畫任務區域（從圓心畫扇形到邊緣）
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: taskArcRadius),
      startAngle,
      sweepAngle,
      true, // 設置為 true，使其形成扇形，並填充顏色
      taskArcPaint,
    );
/*
    // 當鼠標或長按在扇形區域內時顯示文本
    if (showText) {
      double textAngle = startAngle + sweepAngle / 2; // 計算扇形區域的中間角度
      double textRadius = taskArcRadius + 10; // 計算文字顯示的半徑（扇形的外圍）

      // 將文字位置放在扇形區域的外圍
      double textX = centerX + textRadius * cos(textAngle); // 文字的 x 座標
      double textY = centerY + textRadius * sin(textAngle); // 文字的 y 座標

      // 畫文字
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '讀微積分',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );
    }*/

    // 畫指針
    Paint hourHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8;

    Paint minuteHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    Paint secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    double hourAngle = ((dateTime.hour % 12) + dateTime.minute / 60) * 30 * pi / 180;
    double minuteAngle = (dateTime.minute + dateTime.second / 60) * 6 * pi / 180;
    double secondAngle = dateTime.second * 6 * pi / 180;

    // 畫時針
    canvas.drawLine(
      center,
      Offset(centerX + 50 * cos(hourAngle - pi / 2), centerY + 50 * sin(hourAngle - pi / 2)),
      hourHandPaint,
    );

    // 畫分針
    canvas.drawLine(
      center,
      Offset(centerX + 70 * cos(minuteAngle - pi / 2), centerY + 70 * sin(minuteAngle - pi / 2)),
      minuteHandPaint,
    );

    // 畫秒針
    canvas.drawLine(
      center,
      Offset(centerX + 80 * cos(secondAngle - pi / 2), centerY + 80 * sin(secondAngle - pi / 2)),
      secondHandPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
