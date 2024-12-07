import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../dodge_it_game.dart';
import '../utilities/constants.dart';

class Player extends SpriteComponent
    with HasGameRef<DodgeItGame>, CollisionCallbacks {
  int hp = 3;
  double moveSpeed = Constants.playerSpeed;
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    width = 64;
    height = 64;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    _constrainToBounds();
  }

  void moveLeft() {
    velocity.x = -moveSpeed;
  }

  void moveRight() {
    velocity.x = moveSpeed;
  }

  void moveUp() {
    velocity.y = -moveSpeed;
  }

  void moveDown() {
    velocity.y = moveSpeed;
  }

  void stopHorizontalMovement() {
    velocity.x = 0;
  }

  void stopVerticalMovement() {
    velocity.y = 0;
  }

  void _constrainToBounds() {
    final screenBounds = gameRef.size;
    if (x < 0) {
      x = 0;
    } else if (x + width > screenBounds.x) {
      x = screenBounds.x - width;
    }

    if (y < 0) {
      y = 0;
    } else if (y + height > screenBounds.y) {
      y = screenBounds.y - height;
    }
  }
}
