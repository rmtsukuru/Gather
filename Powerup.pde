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

class HealthPack extends Powerup {
  
  static final int HEAL_AMOUNT = 20;
  
  HealthPack() {
    this(0, 0);
  }
  
  HealthPack(float x, float y) {
    super(x, y);
    this.fillColor = color(120, 170, 150);
  }
  
  void grantBoon(Player player) {
    player.health += HEAL_AMOUNT;
    Audio.play("beep01.wav");
  }
}

class Artifact extends Powerup {
  
  Artifact() {
    this(0, 0);
  }
  
  Artifact(float x, float y) {
    super(x, y);
    this.fillColor = color(220, 34, 157);
  }
  
  void grantBoon(Player player) {
    player.hasArtifact = true;
    Audio.play("shriek01.wav");
  }
}