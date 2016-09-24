class Player extends Actor {
  
  static final int SIZE = 30;
  static final int RADIUS = 7;
  static final float SPEED = 5;
  
  static final int JUMP_TIMER_FRAMES = (int) (0.18 * FPS);
  
  final color COLOR = color(0, 200, 250);
  
  Player() {
    this(0, 0);
  }
  
  Player(int x, int y) {
    this.x = x;
    this.y = y;
    this.width = SIZE;
    this.height = SIZE * 2;
    this.speed = SPEED;
    this.fillColor = COLOR;
    this.borderRadius = RADIUS;
    this.jumpTimer = 0;
    this.jumpMax = JUMP_TIMER_FRAMES;
  }
  
  void setVelocity() {
    super.setVelocity();
    handleTileCollision(this);
  }
  
  void update() {
    this.goingLeft = keyState.get(LEFT).beingHeld;
    this.goingRight = keyState.get(RIGHT).beingHeld;
    this.goingDown = keyState.get(DOWN).beingHeld;
    this.goingUp = keyState.get(UP).beingHeld;
    
    if (keyState.get(' ').pressed) {
      this.jumping = true;
    }
    else if (keyState.get(' ').released) {
      this.jumping = false;
    }
    
    super.update();
    resetKeys();
  }
}