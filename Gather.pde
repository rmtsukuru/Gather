import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;

Actor player;

static final int FPS = 60;
static final int ENEMY_SPAWN_RATE = 2;

int counter = 0;

static Gather instance;

void setup() {
    size(640, 480);
    frameRate(FPS);
    
    Gather.instance = this;
    
    Graphics.configure(this);
    Audio.configure(this);
    Input.configure(this);
    Level.configure(this);
    
    player = new Player(180, 200);
    Level.addEntity(player);
}

void draw() {
  background(20, 20, 60);
  
  Level.drawTiles();
  
  counter++;
  if (counter % FPS * ENEMY_SPAWN_RATE == 0) {
    counter = 0;
    float rate = 0.5;
    if (counter > 10 * FPS) {
      rate += 0.1 * (counter / (10.0 * FPS));
    }
    if (Math.random() < rate) {
      Level.addEntity(new Enemy((float) Math.random()*620, (float) Math.random()*460));
    }
  }
  
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