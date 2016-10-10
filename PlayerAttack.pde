abstract class PlayerAttack extends Actor {
  
  abstract int getDamage();
  
  boolean hasGravity() {
    return false;
  }
  
  void update() {
    super.update();
  }
}