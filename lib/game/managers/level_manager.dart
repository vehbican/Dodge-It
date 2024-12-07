class LevelManager {
  double _obstacleSpeed = 100.0;
  double _timeElapsed = 0.0;
  double _incrementInterval = 5.0;
  int _obstacleCount = 1;

  void update(double dt) {
    _timeElapsed += dt;
    if (_timeElapsed >= _incrementInterval) {
      _obstacleSpeed += 10;
      _obstacleCount += 1;
      _timeElapsed = 0.0;
    }
  }

  double get currentObstacleSpeed => _obstacleSpeed;
  int get currentObstacleCount => _obstacleCount;
}
