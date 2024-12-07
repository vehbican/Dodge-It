import 'package:flutter/material.dart';
import '../game/managers/local_score_manager.dart';
import '../game/utilities/sound_manager.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const GameOverOverlay({
    required this.onRestart,
    required this.onMainMenu,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        LocalScoreManager.getHighScore(),
        LocalScoreManager.getAllScores(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final highScore = snapshot.data?[0] as int? ?? 0;
        final allScores = (snapshot.data?[1] as List<int>?) ?? [];

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'High Score: $highScore',
                style: const TextStyle(fontSize: 24, color: Colors.yellow),
              ),
              const SizedBox(height: 10),
              const Text(
                'All Scores:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: allScores.length,
                  itemBuilder: (context, index) {
                    return Text(
                      '${index + 1}. ${allScores[index]}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      SoundManager.playBackgroundMusic();
                      onRestart();
                    },
                    child: const Text('Restart'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      SoundManager.playBackgroundMusic();
                      onMainMenu();
                    },
                    child: const Text('Main Menu'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
