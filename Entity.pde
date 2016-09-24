class Entity {
  float x, y;
  int width, height, borderRadius;
  color strokeColor;
  color fillColor;
  
  Entity() {
    this(0, 0);
  }
  
  Entity(float x, float y) {
    this(x, y, 0, 255);
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