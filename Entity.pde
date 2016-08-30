class Entity {
  float x, y;
  int width, height, borderRadius;
  color strokeColor;
  color fillColor;
  
  Entity() {
    this(0, 0);
  }
  
  Entity(float x, float y) {
    this.x = x;
    this.y = y;
    width = height = 16;
    strokeColor = 0;
    fillColor = 255;
  }
  
  void update() {
    // Do literally nothing.
  }
  
  void draw() {
    stroke(strokeColor);
    fill(fillColor);
    rect(x, y, width, height, borderRadius);
  }
}