static class Graphics {
  
  static PApplet parent;
  
  static void configure(PApplet parent) {
    Graphics.parent = parent;
  }
  
  static void drawBar(int x, int y, int width, int height, float fillRatio, color fillColor) {
    parent.stroke(255);
    parent.fill(0);
    parent.rect(x, y, width, height);
    parent.noStroke();
    parent.fill(fillColor);
    parent.rect(x + 2, y + 2, (width - 3) * fillRatio, height - 3);
  }
}