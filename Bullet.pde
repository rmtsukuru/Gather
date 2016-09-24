class Bullet extends Actor {
  
  static final int WIDTH = 16;
  static final int HEIGHT = 8;
  
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
    this.speed = 10;
  }
  
  boolean hasGravity() {
    return false;
  }
  
  void setVelocity() {
    super.setVelocity();
    handleTileCollision(this);
  }
  
  void update() {
    super.update();
  }
  
  void tileCollisionResponse() {
    this.delete();
  }
}