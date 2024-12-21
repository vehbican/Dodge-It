import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'components/obstacle.dart';
import 'components/powerup.dart';
import 'managers/score_manager.dart';
import 'managers/level_manager.dart';
import 'managers/local_score_manager.dart';
import 'utilities/sound_manager.dart';
import 'dart:math';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

class DodgeItGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player _player;
  late ScoreManager _scoreManager;
  late LevelManager _levelManager;
  final Random random = Random();
  final ValueNotifier<int> playerHpNotifier = ValueNotifier<int>(3);
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  Set<LogicalKeyboardKey> keysPressed = {};

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _initializeGame();
  }

  void _initializeGame() {
    _player = Player()
      ..position = Vector2(size.x / 2, size.y - 100)
      ..anchor = Anchor.center;

    _scoreManager = ScoreManager();
    _levelManager = LevelManager();

    playerHpNotifier.value = 3;
    scoreNotifier.value = 0;

    add(_player);
    _spawnObstaclesAndGolds();
  }

  void reset() {
    SoundManager.playBackgroundMusic();
    children
        .whereType<Component>()
        .forEach((component) => component.removeFromParent());

    _initializeGame();
    resumeEngine();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _player.velocity.setZero();

    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _player.moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _player.moveRight();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      _player.moveUp();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _player.moveDown();
    }

    if (!keysPressed.contains(LogicalKeyboardKey.keyA) &&
        !keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _player.stopHorizontalMovement();
    }

    if (!keysPressed.contains(LogicalKeyboardKey.keyW) &&
        !keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _player.stopVerticalMovement();
    }

    return KeyEventResult.handled;
  }

  void _spawnObstaclesAndGolds() {
    final obstacleSpawnTimer = TimerComponent(
      period: 1.5,
      repeat: true,
      onTick: () {
        for (int i = 0; i < _levelManager.currentObstacleCount; i++) {
          add(
            Obstacle(
              speed: _levelManager.currentObstacleSpeed,
              position: Vector2(
                (size.x * 0.1) + (size.x * 0.8 * random.nextDouble()),
                -50,
              ),
            ),
          );
        }
      },
    );

    final goldSpawnTimer = TimerComponent(
      period: 2.5,
      repeat: true,
      onTick: () {
        add(
          PowerUp(
            speed: _levelManager.currentObstacleSpeed,
            position: Vector2(
              (size.x * 0.1) + (size.x * 0.8 * random.nextDouble()),
              -50,
            ),
          ),
        );
      },
    );

    add(obstacleSpawnTimer);
    add(goldSpawnTimer);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _levelManager.update(dt);
  }

  void onPlayerHitObstacle() {
    _player.hp -= 1;
    playerHpNotifier.value = _player.hp;
    SoundManager.playCollisionSound();

    if (_player.hp <= 0) {
      _handleGameOver();
    }
  }

  void onPlayerCollectGold() {
    _scoreManager.increment(10);
    scoreNotifier.value = _scoreManager.currentScore;

    SoundManager.playPowerUpSound();
  }

  void _handleGameOver() async {
    pauseEngine();
    SoundManager.stop();
    SoundManager.playGameOverSound();

    final currentScore = _scoreManager.currentScore;

    await LocalScoreManager.addScore(currentScore);
    await LocalScoreManager.saveHighScore(currentScore);

    //final highScore = await LocalScoreManager.getHighScore();

    overlays.add('GameOverOverlay');
  }

  @override
  Future<void> onRemove() async {
    playerHpNotifier.dispose();
    scoreNotifier.dispose();
    super.onRemove();
  }

  int get score => _scoreManager.currentScore;
  int get playerHp => _player.hp;
}
