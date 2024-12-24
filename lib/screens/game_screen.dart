import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/dodge_it_game.dart';
import '../overlays/game_over_overlay.dart';
import '../overlays/pause_overlay.dart';
import '../overlays/score_hp_overlay.dart';
import '../game/utilities/sound_manager.dart';
import '../game/managers/local_score_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DodgeItGame _game;
  late Future<List<int>> _sortedScores;

  @override
  void initState() {
    super.initState();
    _game = DodgeItGame(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'GameOverOverlay': (context, game) => GameOverOverlay(
                onRestart: _onRestart, 
                onMainMenu: _goToMainMenu, 
              ),
          'PauseOverlay': (context, game) => PauseOverlay(
                onResume: _onResume, 
              ),
          'ScoreAndHpOverlay': (context, game) => ScoreAndHpOverlay(
                game: _game,
              ),
        },
        initialActiveOverlays: const ['ScoreAndHpOverlay'],
        backgroundBuilder: (context) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          );
        },
      ),
    );
  }

  
  void _goToMainMenu() async {
    await _fetchScores(); 
    final scores = await _sortedScores;
    Navigator.of(context).pop(scores); 
    SoundManager.playBackgroundMusic(); 
  }

  
  Future<void> _fetchScores() async {
    _sortedScores = LocalScoreManager.getSortedScores(); 
    var scores = await _sortedScores;
    print("Fetched scores: $scores");
  }

  
  void _onRestart() {
    _game.reset(); 
    _game.overlays.remove('GameOverOverlay'); 
  }

  
  void _onResume() {
    _game.resumeEngine(); 
    _game.overlays.remove('PauseOverlay'); 
  }
}

