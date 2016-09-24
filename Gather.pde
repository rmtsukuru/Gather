import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;

Actor player;
List<Entity> entities;

static final int FPS = 60;

void setup() {
    size(640, 480);
    frameRate(FPS);
    
    Audio.configure(this);
    Input.configure(this);
    
    player = new Player(180, 200);
    entities = new ArrayList<Entity>(10);
    entities.add(player);
}

void draw() {
  background(20, 20, 60);
  
  for (int i = 0; i < tiles.length; i++) {
    for (int j = 0; j < tiles[i].length; j++) {
      if (tiles[i][j] == 1) {
        stroke(155, 120, 120);
        fill(70, 0, 150);
        rect(j * TILE_SIZE, i * TILE_SIZE, TILE_SIZE, TILE_SIZE);
      }
    }
  }
  
  ListIterator<Entity> iterator = newEntities.listIterator();
  while (iterator.hasNext()) {
    Entity newEntity = iterator.next();
    entities.add(newEntity);
    iterator.remove();
  }
  
  iterator = entities.listIterator();
  while (iterator.hasNext()) {
    Entity entity = iterator.next();
    entity.update();
    entity.draw();
    
    if (entity.deleted) {
      iterator.remove();
    }
  }
}