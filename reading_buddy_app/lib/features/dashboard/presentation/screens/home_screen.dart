import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80),
            SizedBox(height: 16),
            Text('홈 화면 - 출석 달력 및 학습 현황'),
            SizedBox(height: 8),
            Text(
              '여기에 출석 달력, 연속 출석 일수, 오늘의 학습 시간 등이 표시됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
