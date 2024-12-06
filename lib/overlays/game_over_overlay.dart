import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverOverlay({required this.onRestart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Game Over', style: TextStyle(fontSize: 32, color: Colors.white)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRestart,
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}

