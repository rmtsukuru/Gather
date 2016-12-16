static class Graphics {
  static final float BAR_DECAY_RATE = 0.5 / FPS;
  
  static Gather parent;
  
  static float cameraX;
  static float cameraY;
  static PFont font;
  
  static void configure(Gather parent) {
    Graphics.parent = parent;
    
    cameraX = 0;
    cameraY = 0;
    
    if (font == null) {
      font = parent.createFont("fonts/pixelated.ttf", 16);
    }
  }
  
  static PFont getFont() {
    return font;
  }
  
  static void update(Player player) {
    cameraX = player.x - Gather.SCREEN_WIDTH / 2;
    cameraY = player.y - Gather.SCREEN_HEIGHT / 2;
    
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
  
  static void drawDecayingBar(int x, int y, int width, int height, float fillRatio, color fillColor, float decayRatio, color decayColor, 
                                                                   float armorRatio, color armorColor, float shieldRatio, color shieldColor) {
    parent.stroke(255);
    parent.fill(0);
    parent.rect(x, y, width, height);
    parent.noStroke();
    float boundedRatio = max(0, min(shieldRatio, 1));
    parent.fill(shieldColor);
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
    boundedRatio = max(0, min(armorRatio, 1));
    parent.fill(armorColor);
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
    boundedRatio = max(0, min(decayRatio, 1));
    parent.fill(decayColor);
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
    boundedRatio = max(0, min(fillRatio, 1));
    parent.fill(fillColor);
    parent.rect(x + 2, y + 2, (width - 3) * boundedRatio, height - 3);
  }
}