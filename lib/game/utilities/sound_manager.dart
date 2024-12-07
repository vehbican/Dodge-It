import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static bool _initialized = false;
  static bool isMuted = false;

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
    if (!isMuted) {
      FlameAudio.bgm.play('game_music.mp3', volume: 0.3);
    }
  }

  static void playCollisionSound() {
    if (!isMuted) {
      FlameAudio.play('collision.mp3', volume: 1.0);
    }
  }

  static void playPowerUpSound() {
    if (!isMuted) {
      FlameAudio.play('collect_gold.mp3', volume: 1.0);
    }
  }

  static void playGameOverSound() {
    if (!isMuted) {
      FlameAudio.play('game_over.mp3', volume: 1.0);
    }
  }

  static void stop() {
    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
    }
  }

  static void dispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }

  static void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      stop();
    } else {
      playBackgroundMusic();
    }
  }

  static bool getMuteStatus() {
    return isMuted;
  }
}
