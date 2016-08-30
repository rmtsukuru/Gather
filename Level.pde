final int TILE_SIZE = 32;

int[][] tiles = new int[][] {{0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                             {0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0},
                             {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
                            };

void fillMap(ArrayList<Entity> entities) {
  Entity entity = new Entity(300, 246);
  entity.width = entity.height = 80;
  entities.add(entity);
  entities.add(new Entity(120, 90));
}

boolean isPassable(float x, float y) {
  int gridX = (int) Math.floor(x / TILE_SIZE);
  int gridY = (int) Math.floor(y / TILE_SIZE);
  
  if (gridX < 0 || gridX >= tiles[0].length || gridY < 0 || gridY >= tiles.length) {
    return false;
  }
  
  return tiles[gridY][gridX] == 0;
}

void handleCollision(Actor actor) {
  boolean topCollision = !isPassable(actor.x + actor.width / 2 + actor.xVelocity, actor.y + actor.yVelocity);
  boolean bottomCollision = !isPassable(actor.x + actor.width / 2 + actor.xVelocity, actor.y + actor.height + actor.yVelocity);
  boolean leftCollision = !isPassable(actor.x + actor.xVelocity, actor.y + actor.height / 2 + actor.yVelocity);
  boolean rightCollision = !isPassable(actor.x + actor.width + actor.xVelocity, actor.y + actor.height / 2 + actor.yVelocity);
  
  if (leftCollision || rightCollision) {
    actor.xVelocity = 0;
  }
  
  if (topCollision || bottomCollision) {
    actor.yVelocity = 0;
    if (bottomCollision) {
      actor.onGround = true;
    }
  }
}