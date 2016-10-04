class Player extends Actor {
  
  static final int SIZE = 30;
  static final int RADIUS = 7;
  static final float SPEED = 5;
  static final int GUN_HEIGHT = 21;
  
  final color HP_BAR_COLOR = color(50, 180, 120);
  final color HP_DECAY_COLOR = color(255, 0, 0);
  static final int MAX_HP = 100;
  
  static final int JUMP_TIMER_FRAMES = (int) (0.18 * FPS);
  static final int DAMAGE_TIMER_FRAMES = (int) (0.8 * FPS);
  
  final color BORDER_COLOR = color(255, 230, 230);
  final color COLOR = color(0, 200, 250);
  
  int health;
  int damageTimer;
  
  Player() {
    this(0, 0);
  }
  
  Player(int x, int y) {
    this.x = x;
    this.y = y;
    this.width = SIZE;
    this.height = SIZE * 2;
    this.speed = SPEED;
    this.strokeColor = BORDER_COLOR;
    this.fillColor = COLOR;
    this.borderRadius = RADIUS;
    this.jumpTimer = 0;
    this.jumpMax = JUMP_TIMER_FRAMES;
    
    this.health = MAX_HP;
    this.damageTimer = 0;
  }
  
  void setVelocity() {
    super.setVelocity();
    Level.handleTileCollision(this);
  }
  
  void update() {
    this.goingLeft = Input.holdKey(LEFT);
    this.goingRight = Input.holdKey(RIGHT);
    this.goingDown = Input.holdKey(DOWN);
    this.goingUp = Input.holdKey(UP);
    
    if (Input.pressKey(' ')) {
      this.jumping = true;
    }
    else if (Input.releaseKey(' ')) {
      this.jumping = false;
    }
    
    if (Input.pressKey('z')) {
      Bullet bullet = new Bullet(facingRight);
      bullet.y = y + GUN_HEIGHT;
      if (facingRight) {
        bullet.x = x + this.width;
      }
      else {
        bullet.x = x;
      }
      Audio.play("shoot00.wav");
      
      Level.addEntity(bullet);
    }
    
    if (damageTimer > 0) {
      damageTimer--;
    }
    
    super.update();
    Input.resetKeys();
    Level.handleEntityCollision(this);
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof Enemy && damageTimer == 0) {
      damageTimer = DAMAGE_TIMER_FRAMES;
      Enemy enemy = (Enemy) other;
      health -= enemy.getDamage();
    }
  }
}