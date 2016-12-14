class Enemy extends Actor {

  final int MAX_HP_BASE = 40;
  final int MAX_HP_INCREMENT = 10;
  final color HP_BAR_COLOR = color(230, 20, 20);
  final int ATTACK_DAMAGE = 10;
  static final int JUMP_TIMER_FRAMES = (int) (0.2 * FPS);
  static final float SPEED = 1;
  static final float ARTIFACT_SPEED_MODIFIER = 2;
  static final int THOUGHT_TIMER_FRAMES = (int) (1 * FPS);
  static final int LEASH_RADIUS = 250;
  static final float FOLLOW_CHANCE = 0.8;
  
  int health, maxHealth;
  
  int thoughtTimer;
  boolean isMoving;
  
  public Enemy() {
    this(0, 0);
  }
  
  public Enemy(float x, float y) {
    super(x, y);
    this.jumpMax = JUMP_TIMER_FRAMES;
    
    this.fillColor = color(10, 10, 10);
    setMaxHealth();
    health = maxHealth;
    isMoving = false;
  }
  
  void setMaxHealth() {
    float x = (float) Math.random();
    maxHealth = MAX_HP_BASE;
    if (x >= 0.1) {
      maxHealth += MAX_HP_INCREMENT;
    }
    if (x >= 0.5) {
      maxHealth += MAX_HP_INCREMENT;
    }
    if (x >= 0.9) {
      maxHealth += MAX_HP_INCREMENT;
    }
  }
  
  int getDamage() {
    return ATTACK_DAMAGE;
  }
  
  void setSpeed() {
    if (player.hasArtifact) {
      speed = SPEED * ARTIFACT_SPEED_MODIFIER;
    }
    else {
      speed = SPEED;
    }
  }
  
  void setVelocity() {
    this.goingLeft = false;
    this.goingRight = false;
    if (isMoving) {
      if (player.x + player.width/2 < x) {
        this.goingLeft = true;
      }
      else if (player.x + player.width/2 > x + width) {
        this.goingRight = true;
      }
    }
    setSpeed();
    super.setVelocity();
    float tempX = this.xVelocity;
    Level.handleTileCollision(this);
    this.jumping = abs(tempX) > abs(this.xVelocity);
  }
  
  void think() {
    isMoving = false;
    if (player.hasArtifact) {
      isMoving = true;
    }
    else {
      if (this.x - LEASH_RADIUS < player.x + player.width && this.x + this.width + LEASH_RADIUS > player.x &&
          this.y - LEASH_RADIUS < player.y + player.height && this.y + this.height + LEASH_RADIUS > player.y) {
        if (Math.random() < FOLLOW_CHANCE) {
          isMoving = true;
        }
      }
    }
  }
  
  void update() {
    if (thoughtTimer <= 0) {
      think();
      thoughtTimer = THOUGHT_TIMER_FRAMES;
    }
    else {
      thoughtTimer--;
    }
    super.update();
    Level.handleEntityCollision(this);
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof PlayerAttack) {
      PlayerAttack attack = (PlayerAttack) other;
      health -= attack.getDamage(this);
      if (health <= 0) {
        this.delete();
      }
    }
  }
  
  void draw() {
    super.draw();
    if (health < maxHealth) {
      Graphics.drawBar((int) x - 8, (int) y - 18, width + 16, 13, (float) health / maxHealth, HP_BAR_COLOR);
    }
  }
}