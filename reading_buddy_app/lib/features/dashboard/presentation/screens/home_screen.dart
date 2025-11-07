import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80),
            const SizedBox(height: 16),
            const Text('홈 화면 - 출석 달력 및 학습 현황'),
            const SizedBox(height: 8),
            const Text(
              '여기에 출석 달력, 연속 출석 일수, 오늘의 학습 시간 등이 표시됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // VR 기기 연결 버튼
            ElevatedButton.icon(
              onPressed: () {
                context.push('/device-auth');
              },
              icon: const Icon(Icons.devices),
              label: const Text('VR 기기 연결'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
