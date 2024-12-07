import 'package:flutter/material.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const PauseOverlay({required this.onResume, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onResume,
        child: Text('Resume'),
      ),
    );
  }
}
