final int TILE_SIZE = 32;

int[][] tiles = new int[][] {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
                             {1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0}
                            };

List<Entity> newEntities = new LinkedList();

void fillMap(ArrayList<Entity> entities) {
  Entity entity = new Entity(300, 246);
  entity.fillColor = color(200, 0, 255);
  entity.width = entity.height = 80;
  entities.add(entity);
  entities.add(new Entity(120, 90));
}

void addEntity(Entity entity) {
  newEntities.add(entity);
}

int gridIndex(float x) {
  return (int) Math.floor(x / TILE_SIZE);
}

boolean isPassableTile(int gridX, int gridY) {
  if (gridX < 0 || gridX >= tiles[0].length || gridY < 0 || gridY >= tiles.length) {
    return false;
  }
  
  return tiles[gridY][gridX] == 0;
}

boolean isPassable(float x, float y) {
  int gridX = gridIndex(x);
  int gridY = gridIndex(y);
  
  return isPassableTile(gridX, gridY);
}

int tileLeft(int gridX, int gridY) {
  return (gridX * TILE_SIZE);
}

int tileRight(int gridX, int gridY) {
  return (gridX * TILE_SIZE) + TILE_SIZE;
}

int tileTop(int gridX, int gridY) {
  return (gridY * TILE_SIZE);
}

int tileBottom(int gridX, int gridY) {
  return (gridY * TILE_SIZE) + TILE_SIZE;
}

float getCollisionVelocity(boolean horizontal, Actor actor) {
  if (horizontal) {
    // Horizontal
    if (actor.xVelocity < 0) {
      // Left
      int minTileX = gridIndex(actor.x + actor.xVelocity);
      int maxTileX = gridIndex(actor.x + 1) - 1;
      int minTileY = gridIndex(actor.y);
      int maxTileY = gridIndex(actor.y + actor.height - 1);
      rect(minTileX, minTileY, maxTileX - minTileX, maxTileY - minTileY);
      
      for (int i = maxTileX; i >= minTileX; i--) {
        for (int j = minTileY; j <= maxTileY; j++) {
          if (!isPassableTile(i, j)) {
            return max(actor.x - tileRight(i, j), actor.xVelocity);
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
            return max(actor.y - tileBottom(i, j), actor.yVelocity);
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

void handleTileCollision(Actor actor) {
  float startXVelocity = actor.xVelocity;
  float startYVelocity = actor.yVelocity;
  actor.xVelocity = getCollisionVelocity(true, actor);
  actor.yVelocity = getCollisionVelocity(false, actor);
  
  if (startXVelocity != actor.xVelocity || startYVelocity != actor.yVelocity) {
    actor.tileCollisionResponse();
  }
}