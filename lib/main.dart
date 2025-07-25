import 'package:flutter/material.dart';
import 'package:memmerli/screens/login_screen.dart';
import 'package:memmerli/screens/memory_list_screen.dart';
import 'package:memmerli/screens/profile_screen.dart';
import 'package:memmerli/theme/app_theme.dart';

void main() {
  runApp(const MemmerliApp());
}

class MemmerliApp extends StatelessWidget {
  const MemmerliApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memmerli',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/memories': (context) => const MemoryListScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}