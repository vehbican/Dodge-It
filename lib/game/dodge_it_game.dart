import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart'; 
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'components/player.dart';
import 'components/obstacle.dart';
import 'components/powerup.dart';
import 'managers/score_manager.dart';
import 'managers/level_manager.dart';
import 'utilities/constants.dart';
import 'utilities/sound_manager.dart';
import 'dart:math';
import 'package:flame/input.dart'; 
import 'package:flutter/services.dart';

class DodgeItGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player _player;
  late ScoreManager _scoreManager;
  late LevelManager _levelManager;
  final Random random = Random(); // Define a Random instance

    @override
    Future<void> onLoad() async {
    await super.onLoad();

    await SoundManager.initialize();
    SoundManager.playBackgroundMusic();
    
    FlameAudio.bgm.initialize();
    _player = Player()
      ..position = Vector2(size.x / 2, size.y - 100)
      ..anchor = Anchor.center;

    _scoreManager = ScoreManager();
    _levelManager = LevelManager();

    add(_player);

    _spawnObstaclesAndGolds();
  }


  @override
KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  // Check if it's a key down event
  if (event is KeyDownEvent) {
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _player.moveLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _player.moveRight();
    } 
    
  } else if (event is KeyUpEvent) {
    // When keys are released, you might want to stop movement
    if (event.logicalKey == LogicalKeyboardKey.keyA || 
        event.logicalKey == LogicalKeyboardKey.keyD) {
      _player.stopHorizontalMovement();
    }
   
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
    print("player got hit by obstacle");
    _player.hp -= 1;
    SoundManager.playCollisionSound();
    if (_player.hp <= 0) {
      pauseEngine();
      SoundManager.dispose();
      SoundManager.playGameOverSound();

      overlays.add('GameOverOverlay');
    }
  }

  void onPlayerCollectGold() {
    _scoreManager.increment(10);
    print(_scoreManager.currentScore);
    
    SoundManager.playPowerUpSound();
  }

  void reset(){
    print("reset function called");
  }

  int get score => _scoreManager.currentScore;
  int get playerHp => _player.hp;
}

