import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("請填寫表單"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '姓名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入姓名';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '電子郵件'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入電子郵件';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 提交後切換到主畫面
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                },
                child: Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
