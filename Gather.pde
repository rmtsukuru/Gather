import java.util.List;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Map;

static final boolean DEBUG = true;

static final int SCREEN_WIDTH = 640;
static final int SCREEN_HEIGHT = 480;
static final int FPS = 60;
static final int ENEMY_SPAWN_RATE = 2;
static final float BASE_ENEMY_SPAWN_CHANCE = 0.1;
static final float ENEMY_SPAWN_CHANCE_MINUTE_STEP = 0.15;
static final int POWERUP_SPAWN_CAP = 16;
static final float POWERUP_SPAWN_CHANCE = 0.6;
static final int WIN_TIMER_FRAMES = (int) (1.5 * FPS);
static final int TUTORIAL_CUTOFF = 400;

Screen screen;

Player player;

int counter = 0;
int winTimer = WIN_TIMER_FRAMES;
float healthBarTop;
boolean hideTutorial;

static Gather instance;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  frameRate(FPS);
  
  Gather.instance = this;
  hideTutorial = false;
  
  reset();
}

void reset() {
  Graphics.configure(this);
  Audio.configure(this);
  Input.configure(this);
  Level.configure(this);
  
  screen = new GameScreen();
  
  spawnPowerups();
  Artifact artifact = new Artifact();
  artifact.spawn();
  Level.addEntity(artifact);
  
  player = new Player(30, 100);
  healthBarTop = (float) player.health / Player.MAX_HP;
  Level.addEntity(player);
}

void draw() {
  textFont(Graphics.getFont());
  if (DEBUG && Input.pressKey('w')) {
    Level.addEntity(Level.setRandomSpawnPosition(new Enemy(), player));
  }
  if (player.x > TUTORIAL_CUTOFF) {
    hideTutorial = true;
  }
  
  if (screen instanceof GameScreen && player.health <= 0) {
    screen = new DeathScreen();
    player.hidden = true;
  } 
  else if (screen instanceof GameScreen && player.hasArtifact && (player.x == 0 || player.x + player.width == Level.mapWidth())) {
    screen = new WinScreen();
    player.hidden = true;
  }
  
  screen.draw();
}