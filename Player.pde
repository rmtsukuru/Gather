class Player extends Actor {
  
  static final int WIDTH = 27;
  static final int HEIGHT = 60;
  static final int RADIUS = 7;
  static final float SPEED = 5;
  static final int GUN_HEIGHT = 21;
  static final int BLADE_HEIGHT = 28;
  
  final color HP_BAR_COLOR = color(50, 180, 120);
  final color HP_DECAY_COLOR = color(255, 0, 0);
  static final int MAX_HP = 100;
  static final int MAX_LOADED_BULLETS = 6;
  static final int STARTING_BULLETS = 6;
  
  static final int JUMP_TIMER_FRAMES = (int) (0.18 * FPS);
  static final int DAMAGE_TIMER_FRAMES = (int) (0.8 * FPS);
  static final int RELOAD_TIMER_FRAMES = (int) (0.6 * FPS);
  
  final color BORDER_COLOR = color(255, 230, 230);
  final color COLOR = color(0, 200, 250);
  
  int health;
  int bullets;
  int reserveBullets;
  boolean hasArtifact;
  
  int damageTimer;
  int reloadTimer;
  boolean swordDrawn;
  Set<Entity> hitEnemies;
  
  Player() {
    this(0, 0);
  }
  
  Player(int x, int y) {
    this.x = x;
    this.y = y;
    this.width = WIDTH;
    this.height = HEIGHT;
    this.speed = SPEED;
    this.strokeColor = BORDER_COLOR;
    this.fillColor = COLOR;
    this.borderRadius = RADIUS;
    this.jumpTimer = 0;
    this.jumpMax = JUMP_TIMER_FRAMES;
    
    this.health = MAX_HP;
    this.bullets = MAX_LOADED_BULLETS;
    this.reserveBullets = STARTING_BULLETS;
    this.hasArtifact = false;
    this.damageTimer = 0;
    this.swordDrawn = false;
    this.hitEnemies = new HashSet();
  }
  
  void setVelocity() {
    super.setVelocity();
    Level.handleTileCollision(this);
  }
  
  void update() {
    if (health > MAX_HP) {
      health = MAX_HP;
    }
    if (swordDrawn) {
      this.goingLeft = this.goingRight = this.goingUp = this.goingDown = this.jumping = false;
    }
    else {
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
    }
    
    if (reloadTimer > 0) {
      reloadTimer--;
    }
    
    if (Input.pressKey('z')) {
      if (bullets > 0) {
        bullets--;
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
        if (bullets == 0) {
          reloadTimer = RELOAD_TIMER_FRAMES;
        }
      }
      else if(reloadTimer == 0 && reserveBullets > 0) {
        int reloadCount = min(6, reserveBullets);
        reserveBullets -= reloadCount;
        bullets = reloadCount;
        Audio.play("click01.wav");
      }
      else {
        Audio.play("click00.wav");
        reloadTimer = RELOAD_TIMER_FRAMES;
      }
    }
    
    if (Input.pressKey('x') && !swordDrawn) {
      Sword sword = new Sword(this);
      swordDrawn = true;
      Audio.play("slice00.wav");
      
      Level.addEntity(sword);
    }
    
    if (damageTimer > 0) {
      damageTimer--;
    }
    else {
      hitEnemies.clear();
    }
    
    super.update();
    Input.resetKeys();
    Level.handleEntityCollision(this);
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof Enemy && !hitEnemies.contains(other)) {
      if (damageTimer == 0) {
        damageTimer = DAMAGE_TIMER_FRAMES;
      }
      hitEnemies.add(other);
      Enemy enemy = (Enemy) other;
      health -= enemy.getDamage();
      Audio.play("hit00.wav");
    }
  }
}