static class Graphics {
  
  static final float CAMERA_VELOCITY = 3;
  static final float CAMERA_HORIZONTAL_THRESHOLD = 0.4;
  static final float CAMERA_VERTICAL_THRESHOLD = 0.4;
  static final float BAR_DECAY_RATE = 0.5 / FPS;
  
  static PApplet parent;
  
  static float cameraX;
  static float cameraY;
  
  static void configure(PApplet parent) {
    Graphics.parent = parent;
    
    cameraX = 0;
    cameraY = 0;
  }
  
  static void update(Player player) {
    if ((player.x - cameraX) / Gather.SCREEN_WIDTH < CAMERA_HORIZONTAL_THRESHOLD) {
      cameraX -= CAMERA_VELOCITY;
    }
    else if ((player.x - cameraX) / Gather.SCREEN_WIDTH > 1 - CAMERA_HORIZONTAL_THRESHOLD) {
      cameraX += CAMERA_VELOCITY;
    }
    if ((player.y - cameraY) / Gather.SCREEN_HEIGHT < CAMERA_VERTICAL_THRESHOLD) {
      cameraY -= CAMERA_VELOCITY;
    }
    else if ((player.y - cameraY) / Gather.SCREEN_HEIGHT > 1 - CAMERA_VERTICAL_THRESHOLD) {
      cameraY += CAMERA_VELOCITY;
    }
    
    if (cameraX < 0) {
      cameraX = 0;
    }
    else if (cameraX + Gather.SCREEN_WIDTH > Level.mapWidth()) {
      cameraX = Level.mapWidth() - Gather.SCREEN_WIDTH;
    }
    if (cameraY < 0) {
      cameraY = 0;
    }
    else if (cameraY + Gather.SCREEN_HEIGHT > Level.mapHeight()) {
      cameraY = Level.mapHeight() - Gather.SCREEN_HEIGHT;
    }
  }
  
  static void drawRect(float x, float y, float width, float height) {
    drawRect(x, y, width, height, 0);
  }
  
  static void drawRect(float x, float y, float width, float height, float borderRadius) {
    parent.rect(x - cameraX, y - cameraY, width, height, borderRadius);
  }
  
  static void drawBar(int x, int y, int width, int height, float fillRatio, color fillColor) {
    parent.stroke(255);
    parent.fill(0);
    drawRect(x, y, width, height);
    parent.noStroke();
    parent.fill(fillColor);
    float boundedRatio = max(0, min(fillRatio, 1));
    drawRect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
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