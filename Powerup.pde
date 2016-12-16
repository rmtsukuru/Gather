void spawnPowerups() {
  for (int i = 0; i < POWERUP_SPAWN_CAP; i++) {
    if (Math.random() < POWERUP_SPAWN_CHANCE) {
      Level.addEntity(Level.setRandomSpawnPosition(getRandomPowerup(0, 0)));
    }
  }
}

Powerup getRandomPowerup(float x, float y) {
  double random = Math.random();
  if (random < Powerup.SHIELD_RATE) {
    return new Shield(x, y);
  }
  else if (random < Powerup.SHIELD_RATE + Powerup.ARMOR_RATE) {
    return new Armor(x, y);
  }
  else if (random < Powerup.SHIELD_RATE + Powerup.ARMOR_RATE + Powerup.HEALTH_PACK_RATE) {
    return new HealthPack(x, y);
  }
  else if (random < Powerup.SHIELD_RATE + Powerup.ARMOR_RATE + Powerup.HEALTH_PACK_RATE + Powerup.AMMO_RATE) {
    return new Ammo(x, y);
  }
  else {
    return new Bandage(x, y);
  }
}

abstract class Powerup extends Actor {
  
  static final int SIZE = 16;
  static final float SHIELD_RATE = 0.15;
  static final float ARMOR_RATE = 0.15;
  static final float HEALTH_PACK_RATE = 0.15;
  static final float AMMO_RATE = 0.3;
  static final int TEXT_TIMER_FRAMES = (int) (1.5 * FPS);
  
  boolean grabbed;
  int textTimer;
  
  Powerup() {
    super(0, 0);
  }
  
  Powerup(float x, float y) {
    super();
    this.x = x;
    this.y = y;
    this.width = SIZE;
    this.height = SIZE;
    this.grabbed = false;
  }
  
  void update() {
    super.update();
    if (grabbed) {
      if (textTimer <= 0) {
        this.delete();
      }
      else {
        textTimer--;
      }
    }
    else {
      Level.handleTileCollision(this);
    }
  }
  
  boolean hasGravity() {
    return !grabbed;
  }
  
  color getTextColor() {
    return color(255, 255, 255);
  }
  
  void draw() {
    if (grabbed) {
      float timerRatio = 1.0 * textTimer / TEXT_TIMER_FRAMES;
      textSize(22);
      fill(getTextColor(), 255 * timerRatio);
      Graphics.drawText(getBoonText(), x - getBoonText().length(), y - 60 + 60 * timerRatio);
    }
    else {
      super.draw();
    }
  }
  
  void handleEntityCollision(Entity other) {
    if (!grabbed && other instanceof Player) {
      grantBoon((Player) other);
      grabbed = true;
      textTimer = TEXT_TIMER_FRAMES;
    }
  }
  
  abstract void grantBoon(Player player);
  
  abstract String getBoonText();
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
  
  String getBoonText() {
    return "AMMO +" + BULLET_AMOUNT;
  }
}

class Bandage extends Powerup {
  
  static final int SIZE = 13;
  static final int HEAL_AMOUNT = 5;
  
  Bandage() {
    this(0, 0);
  }
  
  Bandage(float x, float y) {
    super(x, y);
    this.fillColor = color(120, 170, 150);
    this.width = this.height = SIZE;
  }
  
  void grantBoon(Player player) {
    player.heal(HEAL_AMOUNT);
    Audio.play("beep01.wav");
  }
  
  color getTextColor() {
    return color(0, 255, 0);
  }
  
  String getBoonText() {
    return "HP +" + HEAL_AMOUNT;
  }
}

class HealthPack extends Powerup {
  
  static final int HEAL_AMOUNT = 50;
  
  HealthPack() {
    this(0, 0);
  }
  
  HealthPack(float x, float y) {
    super(x, y);
    this.fillColor = color(120, 170, 150);
  }
  
  void grantBoon(Player player) {
    player.heal(HEAL_AMOUNT);
    Audio.play("beep01.wav");
  }
  
  color getTextColor() {
    return color(0, 255, 0);
  }
  
  String getBoonText() {
    return "HP +" + HEAL_AMOUNT;
  }
}

class Armor extends Powerup {
  static final int ARMOR_AMOUNT = 70;
  
  Armor() {
    this(0, 0);
  }
  
  Armor(float x, float y) {
    super(x, y);
    this.fillColor = color(180, 180, 0);
  }
  
  void grantBoon(Player player) {
    player.armor += ARMOR_AMOUNT;
    if (player.armor > Player.MAX_ARMOR) {
      player.armor = Player.MAX_ARMOR;
    }
    Audio.play("beep01.wav");
    // TODO add custom sound for this
  }
  
  color getTextColor() {
    return color(255, 255, 0);
  }
  
  String getBoonText() {
    return "ARMOR";
  }
}

class Shield extends Powerup {
  static final int SHIELD_AMOUNT = 30;
  
  Shield() {
    this(0, 0);
  }
  
  Shield(float x, float y) {
    super(x, y);
    this.fillColor = color(40, 60, 180);
  }
  
  void grantBoon(Player player) {
    player.shield += SHIELD_AMOUNT;
    player.hasShield = true;
    if (player.shield > Player.MAX_SHIELD) {
      player.shield = Player.MAX_SHIELD;
    }
    Audio.play("beep01.wav");
    // TODO add custom sound for this
  }
  
  color getTextColor() {
    return color(0, 0, 255);
  }
  
  String getBoonText() {
    return "SHIELD";
  }
}

class Artifact extends Powerup {
  
  int[][] SPAWN_POINTS = {{1904, 2400}, {2440, 1216}, {1899, 1216}, {520, 750}, {4280, 1225}, {3920, 2304}};
  int ENEMY_SUMMON_COUNT = 10;
  
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
    for (int i = 0; i < ENEMY_SUMMON_COUNT; i++) {
      Level.addEntity(Level.setRandomSpawnPosition(new Enemy(), player));
    }
  }
  
  void spawn() {
    int i = (int) (Math.random() * SPAWN_POINTS.length);
    this.x = SPAWN_POINTS[i][0];
    this.y = SPAWN_POINTS[i][1];
  }
  
  color getTextColor() {
    return color(255, 0, 0);
  }
  
  String getBoonText() {
    return "ARTIFACT";
  }
}