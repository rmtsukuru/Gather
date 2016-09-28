import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;

Actor player;

static final int FPS = 60;

static Gather instance;

void setup() {
    size(640, 480);
    frameRate(FPS);
    
    Gather.instance = this;
    
    Audio.configure(this);
    Input.configure(this);
    Level.configure(this);
    
    Level.addEntity(new Enemy(420, 200));
    Level.addEntity(new Enemy(380, 300));
    Level.addEntity(new Enemy(200, 50));
    
    player = new Player(180, 200);
    Level.addEntity(player);
}

void draw() {
  background(20, 20, 60);
  
  Level.drawTiles();
  
  ListIterator<Entity> iterator = Level.newEntities.listIterator();
  while (iterator.hasNext()) {
    Entity newEntity = iterator.next();
    Level.entities.add(newEntity);
    iterator.remove();
  }
  
  iterator = Level.entities.listIterator();
  while (iterator.hasNext()) {
    Entity entity = iterator.next();
    entity.update();
    entity.draw();
    
    if (entity.deleted) {
      iterator.remove();
    }
  }
}