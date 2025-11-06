import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // 프로필 이미지
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          // 닉네임 (나중에 실제 데이터로 대체)
          const Text(
            '닉네임',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // 이메일 (나중에 실제 데이터로 대체)
          Text(
            'email@example.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),

          // 설정 항목들
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('테마 변경'),
            subtitle: const Text('앱의 색상 테마를 선택하세요'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 테마 선택 다이얼로그
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('테마 변경 기능은 추후 추가될 예정입니다')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 정보'),
            subtitle: const Text('버전 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Reading Buddy',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Reading Buddy Team',
                children: [
                  const SizedBox(height: 16),
                  const Text('VR 한글 학습 시스템의 모바일 컴패니언 앱'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final authNotifier = ref.read(authStateProvider.notifier);
                        await authNotifier.logout();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.go(AppRouter.login);
                        }
                      },
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
