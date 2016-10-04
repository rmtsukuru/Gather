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
    float boundedRatio = max(0, min(fillRatio, 1));
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
  }
}