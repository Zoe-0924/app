import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // 引入 intl 套件

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {}; // 用 Map 存事件，支持多個屬性
  TextEditingController _eventController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _eventType = '工作';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('計畫'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showEventsDialog(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              // 確保在訪問 _events[_selectedDay] 前其已經初始化為非null
              return _events[day]?.map((event) => event['name']).toList() ?? [];
            },
          ),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEventDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: (_events[_selectedDay] ?? []).map((event) {
        return ListTile(
          title: Text(event['name']),
          subtitle: Text('${event['time']} - ${event['type']}'),
        );
      }).toList(),
    );
  }

  void _addEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('新增計畫'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(hintText: '輸入計畫'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('選擇時間'),
              trailing: Text('${_selectedTime.format(context)}'),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _eventType,
              items: [
                '工作', '讀書', '睡覺', '運動', '特殊事件', '其他',
              ].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _eventType = newValue!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                setState(() {
                  // 如果當天沒有事件，直接初始化為空列表
                  _events.putIfAbsent(_selectedDay, () => []);
                  _events[_selectedDay]!.add({
                    'name': _eventController.text,
                    'time': _formatTime(_selectedTime), // 使用格式化後的時間
                    'type': _eventType,
                  });
                });
                _eventController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('新增'),
          ),
        ],
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selected != null && selected != _selectedTime) {
      setState(() {
        _selectedTime = selected;
      });
    }
  }

  // 格式化時間：將時間顯示為 "HH:mm"
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final DateFormat formatter = DateFormat('HH:mm'); // 只顯示小時和分鐘
    return formatter.format(dateTime);
  }

  void _showEventsDialog(DateTime day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${day.toLocal()} 的計畫'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (_events[day] ?? [])
              .map((event) => ListTile(
                    title: Text(event['name']),
                    subtitle: Text('${event['time']} - ${event['type']}'),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('關閉'),
          ),
        ],
      ),
    );
  }
}
