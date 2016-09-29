class Enemy extends Actor {

  static final int MAX_HP = 100;
  final color HP_BAR_COLOR = color(230, 20, 20);
  
  int health;
  
  public Enemy() {
    this(0, 0);
  }
  
  public Enemy(float x, float y) {
    super(x, y);
    this.fillColor = color(10, 10, 10);
    this.health = MAX_HP;
  }
  
  void setVelocity() {
    super.setVelocity();
    Level.handleTileCollision(this);
  }
  
  void update() {
    super.update();
    Level.handleEntityCollision(this);
  }
  
  void handleEntityCollision(Entity other) {
    if (other instanceof Bullet) {
      health -= 20;
      if (health <= 0) {
        this.delete();
      }
    }
  }
  
  void drawHealthBar() {
    stroke(255);
    fill(0);
    rect(x - 8, y - 18, width + 16, 13);
    noStroke();
    fill(HP_BAR_COLOR);
    rect(x - 6, y - 16, (width + 13) * (float) health / MAX_HP, 10);
  }
  
  void draw() {
    super.draw();
    if (health < MAX_HP) {
      drawHealthBar();
    }
  }
}