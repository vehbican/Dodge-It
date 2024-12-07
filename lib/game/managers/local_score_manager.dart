import 'package:hive/hive.dart';

class LocalScoreManager {
  static const String _boxName = 'scores';

  static Future<void> saveHighScore(int score) async {
    final box = Hive.box(_boxName);
    final currentHighScore = await getHighScore();

    if (score > (currentHighScore ?? 0)) {
      await box.put('high_score', score);
    }
  }

  static Future<int?> getHighScore() async {
    final box = Hive.box(_boxName);
    return box.get('high_score') as int?;
  }

  static Future<void> addScore(int score) async {
    final box = Hive.box(_boxName);
    final scores = (box.get('all_scores') as List<int>?) ?? [];
    scores.add(score);
    await box.put('all_scores', scores);
  }

  static Future<List<int>> getAllScores() async {
    final box = Hive.box(_boxName);
    return (box.get('all_scores') as List<int>?) ?? [];
  }

  static Future<List<int>> getSortedScores() async {
    final scores = await getAllScores();
    scores.sort((a, b) => b.compareTo(a));
    return scores;
  }
}
