import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final void Function(BuildContext) onStart;

  const MainMenu({required this.onStart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => onStart(context),
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}

