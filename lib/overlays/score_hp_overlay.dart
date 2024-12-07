import 'package:flutter/material.dart';
import '../game/dodge_it_game.dart';

class ScoreAndHpOverlay extends StatelessWidget {
  final DodgeItGame game;

  const ScoreAndHpOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 32),
                const SizedBox(width: 8),
                ValueListenableBuilder<int>(
                  valueListenable: game.playerHpNotifier,
                  builder: (context, hp, child) {
                    return Text(
                      'HP: $hp',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 32),
                const SizedBox(width: 8),
                ValueListenableBuilder<int>(
                  valueListenable: game.scoreNotifier,
                  builder: (context, score, child) {
                    return Text(
                      'Gold: $score',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
