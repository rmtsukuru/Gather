Actor player;
ArrayList<Entity> entities;

static final int FPS = 60;

void setup() {
    size(640, 480);
    frameRate(FPS);
    
    player = new Player(180, 200);
    entities = new ArrayList<Entity>(10);
    entities.add(player);
}

void draw() {
  background(255, 220, 220);
  
  for (int i = 0; i < tiles.length; i++) {
    for (int j = 0; j < tiles[i].length; j++) {
      if (tiles[i][j] == 1) {
        stroke(255, 220, 220);
        fill(255, 0, 0);
        rect(j * TILE_SIZE, i * TILE_SIZE, TILE_SIZE, TILE_SIZE);
      }
    }
  }
  
  for (Entity entity : entities) {
    entity.update();
    entity.draw();
  }
}