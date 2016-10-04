static class Graphics {
  
  static final float BAR_DECAY_RATE = 0.2 / FPS;
  
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
  
  static void drawDecayingBar(int x, int y, int width, int height, float fillRatio, color fillColor, float decayRatio, color decayColor) {
    parent.stroke(255);
    parent.fill(0);
    parent.rect(x, y, width, height);
    parent.noStroke();
    parent.fill(decayColor);
    float boundedRatio = max(0, min(decayRatio, 1));
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
    boundedRatio = max(0, min(fillRatio, 1));
    parent.fill(fillColor);
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
  }
}