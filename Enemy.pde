class Enemy extends Actor {

  static final int MAX_HP = 100;
  final color HP_BAR_COLOR = color(230, 20, 20);
  final int ATTACK_DAMAGE = 5;
  static final int JUMP_TIMER_FRAMES = (int) (0.2 * FPS);
  
  int health;
  
  public Enemy() {
    this(0, 0);
  }
  
  public Enemy(float x, float y) {
    super(x, y);
    this.jumpMax = JUMP_TIMER_FRAMES;
    
    this.fillColor = color(10, 10, 10);
    this.health = MAX_HP;
  }
  
  int getDamage() {
    return ATTACK_DAMAGE;
  }
  
  void setVelocity() {
    this.goingLeft = false;
    this.goingRight = false;
    if (player.x < x) {
      this.goingLeft = true;
    }
    else if (player.x > x + width) {
      this.goingRight = true;
    }
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
      health -= attack.getDamage();
      if (health <= 0) {
        this.delete();
      }
    }
  }
  
  void draw() {
    super.draw();
    if (health < MAX_HP) {
      Graphics.drawBar((int) x - 8, (int) y - 18, width + 16, 13, (float) health / MAX_HP, HP_BAR_COLOR);
    }
  }
}