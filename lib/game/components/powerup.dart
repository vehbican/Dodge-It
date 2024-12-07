import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../dodge_it_game.dart';
import 'player.dart';

class PowerUp extends SpriteComponent
    with HasGameRef<DodgeItGame>, CollisionCallbacks {
  double speed;

  PowerUp({required this.speed, Vector2? position}) {
    this.position = position ?? Vector2.zero();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('powerup.png');
    width = 24;
    height = 24;
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
      gameRef.onPlayerCollectGold();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
