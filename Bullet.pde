class Bullet extends PlayerAttack {
  
  static final int WIDTH = 12;
  static final int HEIGHT = 8;
  static final int SPEED = 18;
  static final int DAMAGE = 30;
  
  final color COLOR = color(200, 150, 0);
  
  Bullet() {
    this(false);
  }
  
  Bullet(boolean facingRight) {
    super();
    this.facingRight = facingRight;
    if (facingRight) {
      goingRight = true;
    }
    else {
      goingLeft = true;
    }
    
    this.width = WIDTH;
    this.height = HEIGHT;
    this.fillColor = COLOR;
    this.speed = SPEED;
  }
  
  int zIndex() {
    return 10;
  }
  
  boolean hasGravity() {
    return false;
  }
  
  int getDamage(Entity entity) {
    if (this.deleted) {
      return 0;
    }
    
    this.delete();
    return DAMAGE;
  }
  
  void setVelocity() {
    super.setVelocity();
    Level.handleTileCollision(this);
  }
  
  void update() {
    super.update();
  }
  
  void handleTileCollision() {
    this.delete();
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof Enemy) {
      this.delete();
    }
  }
  
  void renderGraphics() {
    Graphics.drawImage("bullet0.png", x, y, !facingRight);
  }
}