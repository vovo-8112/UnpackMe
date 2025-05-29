import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/thought_provider.dart';

void main() {
  runApp(const UnpackMeApp());
}

class UnpackMeApp extends StatelessWidget {
  const UnpackMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThoughtProvider(),
      child: MaterialApp(
        title: 'UnpackMe',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
          scaffoldBackgroundColor: const Color(0xFFFFFAF2),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Sans', fontSize: 20),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
