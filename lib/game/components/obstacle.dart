import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../dodge_it_game.dart';
import 'player.dart';

class Obstacle extends SpriteComponent with HasGameRef<DodgeItGame>, CollisionCallbacks {
  double speed;

  Obstacle({required this.speed, Vector2? position}) {
    this.position = position ?? Vector2.zero();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('obstacle.png');
    width = 32;
    height = 32;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y > gameRef.size.y + height) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.onPlayerHitObstacle();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}

