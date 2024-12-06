import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      FlameAudio.bgm.initialize();
      await FlameAudio.audioCache.loadAll([
        'game_music.mp3',
        'collision.mp3',
        'collect_gold.mp3',
        'game_over.mp3'
      ]);
      _initialized = true;
    }
  }

  static void playBackgroundMusic() {
    FlameAudio.bgm.play('game_music.mp3', volume: 0.3);
  }

  static void playCollisionSound() {
    FlameAudio.play('collision.mp3', volume : 1.0);
  }

  static void playPowerUpSound() {
    FlameAudio.play('collect_gold.mp3', volume : 1.0);
  }

  
  static void playGameOverSound() {
    FlameAudio.play('game_over.mp3', volume : 1.0);
  }

  static void dispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }
}

