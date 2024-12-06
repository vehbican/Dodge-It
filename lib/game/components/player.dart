import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../dodge_it_game.dart';
import '../utilities/constants.dart';

class Player extends SpriteComponent with HasGameRef<DodgeItGame>, CollisionCallbacks {
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
  }

  void moveLeft() {
    velocity.x = -moveSpeed;
  }

  void moveRight() {
    velocity.x = moveSpeed;
  }


  void stopHorizontalMovement() {
    velocity.x = 0;
  }

}

