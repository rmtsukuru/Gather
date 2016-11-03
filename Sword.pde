import java.util.Set;
import java.util.HashSet;

class Sword extends PlayerAttack {
  
  static final int WIDTH = 68;
  static final int HEIGHT = 3;
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
  
  void update() {
    super.setVelocity();
    this.x = player.x;
    if (player.facingRight) {
      this.x += player.width;
    }
    else {
      this.x -= this.width;
    }
    this.y = player.y + Player.BLADE_HEIGHT;
    
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
  }
  
  int getDamage(Entity entity) {
    if (damagedTargets.contains(entity)) {
      return 0;
    }
    
    damagedTargets.add(entity);
    return DAMAGE;
  }
}