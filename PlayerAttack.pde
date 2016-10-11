abstract class PlayerAttack extends Actor {
  
  abstract int getDamage(Entity entity);
  
  void update() {
    super.update();
  }
}