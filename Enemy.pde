class Enemy extends Actor {

  final int MAX_HP_BASE = 40;
  final int MAX_HP_INCREMENT = 10;
  final color HP_BAR_COLOR = color(230, 20, 20);
  final int ATTACK_DAMAGE = 10;
  static final int JUMP_TIMER_FRAMES = (int) (0.2 * FPS);
  static final float SPEED = 1;
  static final float ARTIFACT_SPEED_MODIFIER = 3;
  
  int health, maxHealth;
  
  public Enemy() {
    this(0, 0);
  }
  
  public Enemy(float x, float y) {
    super(x, y);
    this.jumpMax = JUMP_TIMER_FRAMES;
    
    this.fillColor = color(10, 10, 10);
    setMaxHealth();
    health = maxHealth;
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
    if (player.x + player.width/2 < x) {
      this.goingLeft = true;
    }
    else if (player.x + player.width/2 > x + width) {
      this.goingRight = true;
    }
    setSpeed();
    super.setVelocity();
    float tempX = this.xVelocity;
    Level.handleTileCollision(this);
    this.jumping = abs(tempX) > abs(this.xVelocity);
  }
  
  void update() {
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