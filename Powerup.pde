abstract class Powerup extends Actor {
  
  static final int SIZE = 16;
  
  Powerup() {
    super(0, 0);
  }
  
  Powerup(float x, float y) {
    super();
    this.x = x;
    this.y = y;
    this.width = SIZE;
    this.height = SIZE;
  }
  
  void update() {
    super.update();
    Level.handleTileCollision(this);
  }
  
  boolean hasGravity() {
    return true;
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof Player) {
      grantBoon((Player) other);
      this.delete();
    }
  }
  
  abstract void grantBoon(Player player);
}

class Ammo extends Powerup {
  
  static final int BULLET_AMOUNT = 6;
  
  Ammo() {
    this(0, 0);
  }
  
  Ammo(float x, float y) {
    super(x, y);
    this.fillColor = color(160, 130, 140);
  }
  
  void grantBoon(Player player) {
    player.reserveBullets += BULLET_AMOUNT;
    Audio.play("beep00.wav");
  }
}