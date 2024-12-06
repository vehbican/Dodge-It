import 'package:flutter/material.dart';
import 'screens/main_menu.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const DodgeItApp());
}

class DodgeItApp extends StatelessWidget {
  const DodgeItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dodge It',
      home: MainMenu(
        onStart: (ctx) {
          Navigator.of(ctx).push(
            MaterialPageRoute(builder: (_) => const GameScreen()),
          );
        },
      ),
    );
  }
}

