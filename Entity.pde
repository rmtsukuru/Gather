class Entity {
  static final int FLASH_TIMER_FRAMES = (int) (0.1 * FPS);
  
  float x, y;
  int width, height, borderRadius;
  color strokeColor;
  color fillColor;
  boolean deleted;
  boolean flashing;
  boolean hidden;
  int flashTimer;
  
  Entity() {
    this(0, 0);
  }
  
  Entity(float x, float y) {
    this(x, y, 180, 255);
  }
  
  Entity(float x, float y, color strokeColor, color fillColor) {
    this(x, y, strokeColor, fillColor, 32);
  }
  
  Entity(float x, float y, color strokeColor, color fillColor, int size) {
    this.x = x;
    this.y = y;
    width = height = size;
    this.strokeColor = strokeColor;
    this.fillColor = fillColor;
    this.deleted = false;
    this.flashing = false;
    this.hidden = false;
    this.flashTimer = 0;
  }
  
  int zIndex() {
    return 0;
  }
  
  void update() {
    // Do literally nothing (except update flash timer).
    if (flashing) {
      if (flashTimer <= 0) {
        hidden = !hidden;
        flashTimer = FLASH_TIMER_FRAMES;
      }
      else {
        flashTimer--;
      }
    }
  }
  
  // This draws the graphics directly without deciding whether or not it should.
  void renderGraphics() {
    if (strokeColor < 0) {
      noStroke();
    }
    else {
      stroke(strokeColor);
    }
    fill(fillColor);
    Graphics.drawRect(x, y, width, height, borderRadius);
  }
  
  // This draws the sprite/graphic, but first checks to see if it's hidden (e.g. because it's dead or flashing).
  void draw() {
    if (!hidden) {
      noTint();
      renderGraphics();
    }
  }
  
  void delete() {
    deleted = true;
  }
}