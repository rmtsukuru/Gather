void spawnInitialSnow() {
  int snowflakes = (int) Math.ceil(Math.random() * 100) + 1;
  for (int i = 0; i < snowflakes; i++) {
    Level.addEntity(new SnowParticle());
  }
}

class SnowParticle extends Actor {
  static final int MAX_VELOCITY = 4;
  static final int TTL = FPS * 60;
  
  int timer;
  
  SnowParticle() {
    super();
    x = (float) (Math.random() * Level.mapWidth());
    y = (float) (Math.random() * 10);
    width = 4;
    height = 4;
    fillColor = color(255, 255, 255);
    strokeColor = -1;
    
    // X velocity should be in range of -1 * MAX_VELOCITY to MAX_VELOCITY.
    xVelocity = (float) (Math.random() * 2 * MAX_VELOCITY) - MAX_VELOCITY;
    timer = TTL;
  }
  
  int zIndex() {
    return 20;
  }
  
  void setVelocity() {
    applyGravity();
    Level.handleTileCollision(this);
  }
  
  void update() {
    super.update();
    timer--;
    if (y > Level.mapHeight() || timer <= 0) {
      delete();
    }
  }
  
  void handleTileCollision() {
    this.xVelocity = 0;
  }
}