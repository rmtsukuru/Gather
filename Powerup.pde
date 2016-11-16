void spawnPowerups() {
  for (int i = 0; i < POWERUP_SPAWN_CAP; i++) {
    if (Math.random() < POWERUP_SPAWN_CHANCE) {
      Level.addEntity(Level.setRandomSpawnPosition(getRandomPowerup(0, 0)));
    }
  }
}

Powerup getRandomPowerup(float x, float y) {
  if (Math.random() < Powerup.HEALTH_PACK_RATE) {
    return new HealthPack(x, y);
  }
  else {
    return new Ammo(x, y);
  }
}

abstract class Powerup extends Actor {
  
  static final int SIZE = 16;
  static final float HEALTH_PACK_RATE = 0.4;
  
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
  
  int[][] SPAWN_POINTS = {{1888, 2400}, {2440, 1216}, {1899, 1216}, {520, 750}, {4280, 1225}};
  
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
  
  void spawn() {
    int i = (int) (Math.random() * SPAWN_POINTS.length);
    this.x = SPAWN_POINTS[i][0];
    this.y = SPAWN_POINTS[i][1];
  }
}