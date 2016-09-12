class Player extends Actor {
  
  static final int SIZE = 32;
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
    this.width = this.height = SIZE;
    this.speed = SPEED;
    this.fillColor = COLOR;  
    this.borderRadius = RADIUS;
    this.jumpTimer = 0;
    this.jumpMax = JUMP_TIMER_FRAMES;
  }
  
  void setVelocity() {
    super.setVelocity();
    handleCollision(this);
  }
}