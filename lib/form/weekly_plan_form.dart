import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeeklyPlanForm(),
    );
  }
}

class WeeklyPlanForm extends StatefulWidget {
  @override
  _WeeklyPlanFormState createState() => _WeeklyPlanFormState();
}

class _WeeklyPlanFormState extends State<WeeklyPlanForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Map<int, Map<String, String>>> _weeklyPlan = {
    for (var day in [
      '星期一',
      '星期二',
      '星期三',
      '星期四',
      '星期五',
      '星期六',
      '星期日'
    ])
      day: {}
  };

  final List<String> _planTypes = ['工作', '運動', '學習', '休息', '其他'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('一週計畫問卷'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              for (var day in _weeklyPlan.keys)
                _buildDayPlanForm(day),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 提交後切換到主畫面
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                },
                child: Text('提交計畫'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayPlanForm(String day) {
    return ExpansionTile(
      title: Text(day),
      children: [
        for (var hour = 0; hour < 24; hour++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('${hour}:00-${hour + 1}:00'),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '選擇類型',
                    ),
                    items: _planTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _weeklyPlan[day]![hour] ??= {};
                        _weeklyPlan[day]![hour]!['type'] = value;
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '計畫細節',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _weeklyPlan[day]![hour] ??= {};
                        _weeklyPlan[day]![hour]!['details'] = value;
                      } else if (_weeklyPlan[day]![hour] != null) {
                        _weeklyPlan[day]![hour]!.remove('details');
                        if (_weeklyPlan[day]![hour]!.isEmpty) {
                          _weeklyPlan[day]!.remove(hour);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  /*
  void _submitPlan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 顯示計畫資料
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('計畫提交成功'),
            content: SingleChildScrollView(
              child: Text(_formatWeeklyPlan()),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('確定'),
              ),
            ],
          );
        },
      );
    }
  }

  String _formatWeeklyPlan() {
    String result = '';
    _weeklyPlan.forEach((day, plans) {
      result += '$day:\n';
      plans.forEach((hour, plan) {
        result +=
            '  ${hour}:00-${hour + 1}:00: ${plan['type'] ?? '未選擇類型'} - ${plan['details'] ?? '無細節'}\n';
      });
      if (plans.isEmpty) {
        result += '  無計畫\n';
      }
    });
    return result;
  }*/
}
