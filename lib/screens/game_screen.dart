import 'package:flutter/material.dart';
import 'package:flame/game.dart'; 
import '../game/dodge_it_game.dart';
import '../overlays/game_over_overlay.dart';
import '../overlays/pause_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DodgeItGame _game;

  @override
  void initState() {
    super.initState();
    _game = DodgeItGame();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: _game,
      overlayBuilderMap: {
        'GameOverOverlay': (context, game) => GameOverOverlay(onRestart: _onRestart),
        'PauseOverlay': (context, game) => PauseOverlay(onResume: _onResume),
      },
    );
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

