import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;

Player player;

static final int SCREEN_WIDTH = 640;
static final int SCREEN_HEIGHT = 480;
static final int FPS = 60;
static final int ENEMY_SPAWN_RATE = 2;
static final int POWERUP_SPAWN_RATE = 4;
static final int EXIT_TIMER_FRAMES = (int) (0.45 * FPS);

int counter = 0;
int exitTimer = EXIT_TIMER_FRAMES;
float healthBarTop;

static Gather instance;

void settings() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
    frameRate(FPS);
    
    Gather.instance = this;
    
    Graphics.configure(this);
    Audio.configure(this);
    Input.configure(this);
    Level.configure(this);
    
    player = new Player(180, 200);
    healthBarTop = (float) player.health / Player.MAX_HP;
    Level.addEntity(player);
}

Powerup getRandomPowerup(float x, float y) {
  if (Math.random() < 0.4) {
    return new HealthPack(x, y);
  }
  else {
    return new Ammo(x, y);
  }
}

void draw() {
  background(20, 20, 60);
  
  Level.drawTiles();
  
  counter++;
  if (counter % (FPS * ENEMY_SPAWN_RATE) == 0) {
    float rate = 0.3;
    if (counter > 10 * FPS) {
      rate += 0.1 * (counter / (10.0 * FPS));
    }
    if (Math.random() < rate) {
      Level.addEntity(new Enemy((float) Math.random()*620, (float) Math.random()*460));
    }
  }
  if (counter % (FPS * POWERUP_SPAWN_RATE) == 0) {
    if (Math.random() < 0.6) {
      Level.addEntity(getRandomPowerup((float) Math.random()*620, (float) Math.random()*460));
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
  
  Graphics.update(player);
  
  if (healthBarTop * Player.MAX_HP > player.health) {
    if (player.damageTimer == 0) {
      healthBarTop -= Graphics.BAR_DECAY_RATE;
    }
  }
  else {
    healthBarTop = (float) player.health / Player.MAX_HP;
  }
  fill(255);
  text("Health:", 5, 20);
  Graphics.drawDecayingBar(50, 8, 120, 16, (float) player.health / Player.MAX_HP, player.HP_BAR_COLOR, 
                                            healthBarTop, player.HP_DECAY_COLOR);
  fill(255);
  text("Ammo: " + player.bullets + "/" + player.reserveBullets, 5, 40);
  
  if (player.health <= 0) {
    if (exitTimer == 0) {
      System.exit(0);
    }
    else {
      exitTimer--;
      fill(255, 0, 0);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
  }
}