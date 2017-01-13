import java.util.Set;
import java.util.HashSet;

class Sword extends PlayerAttack {
  
  static final int WIDTH = 51;
  static final int HEIGHT = 10;
  static final int DAMAGE = 20;
  static final int TTL = (int) (1.0/3 * FPS);
  
  final color COLOR = color(180, 0, 20);
  
  Player player;
  int timer;
  Set<Entity> damagedTargets;
  
  Sword(Player player) {
    super();
    this.player = player;
    this.timer = TTL;
    this.damagedTargets = new HashSet();
    
    this.width = 0;
    this.height = HEIGHT;
    this.fillColor = COLOR;
  }
  
  int zIndex() {
    return 5;
  }
  
  int getDamage(Entity entity) {
    if (damagedTargets.contains(entity)) {
      return 0;
    }
    
    damagedTargets.add(entity);
    return DAMAGE;
  }
  
  void update() {
    super.setVelocity();
    
    this.timer--;
    if (timer <= 0) {
      player.swordDrawn = false;
      delete();
    }
    else if (timer <= TTL / 3) {
      width -= round((WIDTH / (TTL / 3)));
    }
    else if (timer > TTL * 2 / 3) {
      width += round((WIDTH / (TTL / 3)));
    }
    
    this.x = player.x;
    if (player.facingRight) {
      this.x += player.width;
    }
    else {
      this.x -= this.width;
    }
    this.y = player.y + Player.BLADE_HEIGHT;
  }
  
  void renderGraphics() {
    String frame = "sword0.png";
    if (width > WIDTH * 0.8) {
      frame = "sword1.png";
    }
    else if (timer < TTL * 2 / 3) {
      frame = "sword2.png";
    }
    Graphics.drawImage(frame, x + (player.facingRight ? 0 : width - WIDTH), y, !player.facingRight);
  }
}