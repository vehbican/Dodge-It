import 'package:flutter/material.dart';

class Scoreboard extends StatelessWidget {
  final int score;
  final int highScore;

  const Scoreboard({required this.score, required this.highScore, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Score: $score', style: TextStyle(fontSize: 24)),
        Text('High Score: $highScore', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

