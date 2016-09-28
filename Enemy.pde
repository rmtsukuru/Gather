class Enemy extends Actor {
  
  public Enemy() {
    this(0, 0);
  }
  
  public Enemy(float x, float y) {
    super(x, y);
    this.fillColor = color(10, 10, 10);
  }
  
  void setVelocity() {
    super.setVelocity();
    handleTileCollision(this);
  }
  
  void update() {
    super.update();
    handleEntityCollision(this);
  }
  
  void collisionResponse(Entity other) {
    if (other instanceof Bullet) {
      this.delete();
    }
  }
}