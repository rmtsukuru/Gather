static class Level {
  
  static final int TILE_SIZE = 32;

  static int[][] tiles;

  static List<Entity> entities;
  static List<Entity> newEntities;
  
  static PApplet parent;
  
  static void loadMap(String filename) {
    List<String> lines = new LinkedList();
    BufferedReader reader = parent.createReader("levels/" + filename);
    try {
      String currentLine = reader.readLine();
      while(currentLine != null) {
        lines.add(currentLine);
        currentLine = reader.readLine();
      }
      reader.close();
    }
    catch (IOException e) {
      println("Failed to load map data, terminating.");
      e.printStackTrace();
      System.exit(-1);
    }
    tiles = new int[lines.size()][];
    for (int i = 0; i < lines.size(); i++) {
      char[] temp = lines.get(i).toCharArray();
      tiles[i] = new int[temp.length];
      for (int j = 0; j < temp.length; j++) {
        tiles[i][j] = Integer.parseInt("" + temp[j]);
      }
    }
  }

  static void configure(PApplet parent) {
    Level.parent = parent;
    
    loadMap("map01");
    
    entities = new LinkedList();
    newEntities = new LinkedList();
  }

  static void addEntity(Entity entity) {
    newEntities.add(entity);
  }
  
  static void drawTiles() {
    int minX = gridIndex(Graphics.cameraX);
    int maxX = gridIndex(Graphics.cameraX + SCREEN_WIDTH);
    int minY = gridIndex(Graphics.cameraY);
    int maxY = gridIndex(Graphics.cameraY + SCREEN_HEIGHT);
    for (int i = minY; i <= maxY; i++) {
      for (int j = minX; j <= maxX; j++) {
        if (i < tiles.length && j < tiles[i].length && tiles[i][j] == 1) {
          parent.stroke(155, 120, 120);
          parent.fill(70, 0, 150);
          Graphics.drawRect(j * TILE_SIZE, i * TILE_SIZE, TILE_SIZE, TILE_SIZE);
        }
      }
    }
  }
  
  static int mapWidth() {
    return TILE_SIZE * tiles[0].length;
  }
  
  static int mapHeight() {
    return TILE_SIZE * tiles.length;
  }

  static int gridIndex(float x) {
    return (int) Math.floor(x / TILE_SIZE);
  }

  static boolean isPassableTile(int gridX, int gridY) {
    if (gridX < 0 || gridX >= tiles[0].length || gridY < 0 || gridY >= tiles.length) {
      return false;
    }
  
    return tiles[gridY][gridX] == 0;
  }

  static boolean isPassable(float x, float y) {
    int gridX = gridIndex(x);
    int gridY = gridIndex(y);
  
    return isPassableTile(gridX, gridY);
  }
  
  static int scalarGridIndex(int x, int y) {
    return x + (y * tiles[0].length);
  }
  
  static int gridXFromScalar(int i) {
    return i % tiles[0].length;
  }
  
  static int gridYFromScalar(int i) {
    return i / tiles[0].length;
  }

  static int tileLeft(int gridX, int gridY) {
    return (gridX * TILE_SIZE);
  }

  static int tileRight(int gridX, int gridY) {
    return (gridX * TILE_SIZE) + TILE_SIZE;
  }

  static int tileTop(int gridX, int gridY) {
    return (gridY * TILE_SIZE);
  }

  static int tileBottom(int gridX, int gridY) {
    return (gridY * TILE_SIZE) + TILE_SIZE;
  }
  
  static Entity setRandomSpawnPosition(Entity subject, int minTileX, int maxTileX, int minTileY, int maxTileY) {
    List<Integer> passableTiles = new ArrayList();
    for (int i = minTileX; i <= maxTileX; i++) {
      for (int j = minTileY; j <= maxTileY; j++) {
        if (isPassableTile(i, j)) {
          passableTiles.add(scalarGridIndex(i, j));
        }
      }
    }
    int randomTile = Math.round((float) Math.random() * passableTiles.size());
    int scalar = passableTiles.get(min(randomTile, passableTiles.size()-1));
    subject.x = tileLeft(gridXFromScalar(scalar), gridYFromScalar(scalar));
    subject.y = tileTop(gridXFromScalar(scalar), gridYFromScalar(scalar));
    return subject;
  }
  
  static Entity setRandomSpawnPosition(Entity subject, Player player) {
    int minTileX = gridIndex(max(0, player.x - Gather.SCREEN_WIDTH / 2));
    int maxTileX = gridIndex(min(mapWidth(), player.x + Gather.SCREEN_WIDTH / 2));
    int minTileY = gridIndex(max(0, player.y - Gather.SCREEN_HEIGHT / 2));
    int maxTileY = gridIndex(min(mapHeight(), player.y + Gather.SCREEN_HEIGHT / 2));
    
    return setRandomSpawnPosition(subject, minTileX, maxTileX, minTileY, maxTileY);
  }
  
  static Entity setRandomSpawnPosition(Entity subject) {
    return setRandomSpawnPosition(subject, 0, (mapWidth() / TILE_SIZE) - 1, 0, (mapHeight() / TILE_SIZE) - 1);
  }

  static boolean areColliding(Entity a, Entity b) {
    return a.x < b.x + b.width && b.x < a.x + a.width && a.y < b.y + b.height && b.y < a.y + a.height;
  }

  static float getCollisionVelocity(boolean horizontal, Actor actor) {
    if (horizontal) {
      // Horizontal
      if (actor.xVelocity < 0) {
        // Left
        int minTileX = gridIndex(actor.x + actor.xVelocity);
        int maxTileX = gridIndex(actor.x + 1) - 1;
        int minTileY = gridIndex(actor.y);
        int maxTileY = gridIndex(actor.y + actor.height - 1);
        
        for (int i = maxTileX; i >= minTileX; i--) {
          for (int j = minTileY; j <= maxTileY; j++) {
            if (!isPassableTile(i, j)) {
              return max(tileRight(i, j) - actor.x, actor.xVelocity);
            }
          }
        }
      }
      else if (actor.xVelocity > 0) {
        // Right
        int minTileX = gridIndex(actor.x + actor.width - 1) + 1;
        int maxTileX = gridIndex(actor.x + actor.width + actor.xVelocity);
        int minTileY = gridIndex(actor.y);
        int maxTileY = gridIndex(actor.y + actor.height - 1);
        
        for (int i = minTileX; i <= maxTileX; i++) {
          for (int j = minTileY; j <= maxTileY; j++) {
            if (!isPassableTile(i, j)) {
              return min(tileLeft(i, j) - (actor.x + actor.width), actor.xVelocity);
            }
          }
        }
      }
      return actor.xVelocity;
    }
    else {
      // Vertical
      float tempX = actor.x + actor.xVelocity;
      
      if (actor.yVelocity < 0) {
        // Top
        int minTileY = gridIndex(actor.y + actor.yVelocity);
        int maxTileY = gridIndex(actor.y) - 1;
        int minTileX = gridIndex(tempX);
        int maxTileX = gridIndex(tempX + actor.width - 1);
        
        for (int j = maxTileY; j >= minTileY; j--) {
          for (int i = minTileX; i <= maxTileX; i++) {
            if (!isPassableTile(i, j)) {
              return max(tileBottom(i, j) - actor.y, actor.yVelocity);
            }
          }
        }
      }
      else if (actor.yVelocity > 0) {
        // Bottom
        int minTileY = gridIndex(actor.y + actor.height - 1) + 1;
        int maxTileY = gridIndex(actor.y + actor.height + actor.yVelocity);
        int minTileX = gridIndex(tempX);
        int maxTileX = gridIndex(tempX + actor.width - 1);
        
        for (int j = minTileY; j <= maxTileY; j++) {
          for (int i = minTileX; i <= maxTileX; i++) {
            if (!isPassableTile(i, j)) {
              if (!actor.goingUp) {
                actor.onGround = true;
                actor.jumping = false;
              }
              return min(tileTop(i, j) - (actor.y + actor.height), actor.yVelocity);
            }
          }
        }
      }
      return actor.yVelocity;  
    }
  }
  
  static void handleTileCollision(Actor actor) {
    float startXVelocity = actor.xVelocity;
    float startYVelocity = actor.yVelocity;
    actor.xVelocity = getCollisionVelocity(true, actor);
    actor.yVelocity = getCollisionVelocity(false, actor);
    
    if (startXVelocity != actor.xVelocity || startYVelocity != actor.yVelocity) {
      actor.handleTileCollision();
    }
  }
  
  static void handleEntityCollision(Actor actor) {
    for (Entity entity : entities) {
      if (areColliding(actor, entity)) {
        actor.handleEntityCollision(entity);
        if (!(entity instanceof Enemy)) {
          Actor other = (Actor) entity;
          other.handleEntityCollision(actor);
        }
      }
    }
  }
}