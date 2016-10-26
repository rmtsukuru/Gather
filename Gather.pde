import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;

Player player;

static final int SCREEN_WIDTH = 640;
static final int SCREEN_HEIGHT = 480;
static final int FPS = 60;
static final int ENEMY_SPAWN_RATE = 4;
static final int POWERUP_SPAWN_RATE = 8;
static final int DEATH_TIMER_FRAMES = (int) (0.45 * FPS);
static final int WIN_TIMER_FRAMES = (int) (1.5 * FPS);

int counter = 0;
int deathTimer = DEATH_TIMER_FRAMES;
int winTimer = WIN_TIMER_FRAMES;
boolean winning;
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
  
  Level.addEntity(new Artifact(800, 300));
  
  
  player = new Player(30, 100);
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
    if (counter > 60 * FPS) {
      rate += 0.1 * (counter / (60.0 * FPS));
    }
    if (Math.random() < rate) {
      Level.addEntity(Level.setRandomSpawnPosition(new Enemy(), player));
    }
  }
  if (counter % (FPS * POWERUP_SPAWN_RATE) == 0) {
    if (Math.random() < 0.6) {
      Level.addEntity(Level.setRandomSpawnPosition(getRandomPowerup(0, 0), player));
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

  if (player.hasArtifact) {
    text("Artifact retrieved", 5, 60);
  }

  if (player.health <= 0) {
    if (deathTimer == 0) {
      System.exit(0);
    }
    else {
      deathTimer--;
      fill(255, 0, 0);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
  } 
  else if (player.hasArtifact && (winning || player.x == 0 || player.x + player.width == Level.mapWidth())) {
    winning = true;
    if (winTimer == 0) {
      System.exit(0);
    }
    else {
      winTimer--;
      fill(190, 0, 255, 80);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      fill(255, 255, 255);
      text("Mission accomplished!", SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT / 2);
    }
  }
  else {
    fill(120, 120, 150, 80);
    rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  }
}