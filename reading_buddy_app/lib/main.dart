import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 초기화
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 선택된 테마 (기본: warm)
    final tokenStorage = ref.watch(tokenStorageProvider);
    final selectedTheme = tokenStorage.getSelectedTheme() ?? AppTheme.warm;

    return MaterialApp.router(
      title: 'Reading Buddy',
      theme: AppTheme.getTheme(selectedTheme),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
