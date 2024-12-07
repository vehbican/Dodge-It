class ScoreManager {
  int _score = 0;

  void increment(int amount) {
    _score += amount;
  }

  int get currentScore => _score;
}
