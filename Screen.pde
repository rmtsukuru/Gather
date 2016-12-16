interface Screen {
  void draw();
}

class GameScreen implements Screen {
  
  void handleSpawning() {
    counter++;
    if (counter % (FPS * ENEMY_SPAWN_RATE) == 0) {
      float rate = BASE_ENEMY_SPAWN_CHANCE;
      if (counter > 60 * FPS) {
        rate += ENEMY_SPAWN_CHANCE_MINUTE_STEP * (counter / (60.0 * FPS));
      }
      if (player.hasArtifact) {
        rate += 2;
      }
      if (Math.random() < rate) {
        Level.addEntity(Level.setRandomSpawnPosition(new Enemy(), player));
        if (rate > 1) {
          for (int i = 0; i < Math.round(Math.random() * (2 * rate)); i++) {
            Level.addEntity(Level.setRandomSpawnPosition(new Enemy(), player));
            if (Math.random() > 0.75) {
              break;
            }
          }
        }
      }
    }
  }
  
  void drawHud() {
    textSize(18);
    if (healthBarTop * Player.MAX_HP > player.health) {
      if (player.damageTimer == 0) {
        healthBarTop -= Graphics.BAR_DECAY_RATE;
      }
    }
    else {
      healthBarTop = (float) player.health / Player.MAX_HP;
    }
    fill(255);
    text("HEALTH:", 5, 22);
    Graphics.drawDecayingBar(70, 8, (int) (120 * (player.effectiveMaxHP() / 100.0)), 16, 
      (float) player.health / player.effectiveMaxHP(), player.HP_BAR_COLOR, healthBarTop * Player.MAX_HP / player.effectiveMaxHP(), player.HP_DECAY_COLOR, 
      (float) (player.armor + player.health) / player.effectiveMaxHP(), player.HP_ARMOR_COLOR, 
      (float) (player.shield + player.armor + player.health) / player.effectiveMaxHP(), player.HP_SHIELD_COLOR);
    fill(255);
    text("Z         REVOLVER   [AMMO:     " + player.bullets + "/" + player.reserveBullets + "]", 5, 44);
    text("X         SABER", 5, 64);
    
    String objectiveText;
    if (player.hasArtifact) {
      objectiveText = "RETURN TO SURFACE AND RETREAT";
    }
    else {
      objectiveText = "FIND AND COLLECT THE";
      fill(255, 0, 0);
      text("ARTIFACT", 270, 84);
    }
    fill(255);
    text("OBJECTIVE:   " + objectiveText, 5, 84);
    
    if (!hideTutorial) {
      text("USE ARROW KEYS TO MOVE LEFT AND RIGHT", 260, 140);
      text("PRESS SPACEBAR TO JUMP", 260, 170);
    }
  }
  
  public void draw() {
    if (Input.pressKey('q')) {
      Gather.instance.screen = new PauseScreen();
    }
    
    background(20, 20, 60);

    Level.drawTiles();
    
    handleSpawning();
  
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
    
    fill(120, 120, 150, 80);
    rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  
    Graphics.update(player);
    
    drawHud();
  }
}

class PauseScreen extends GameScreen {
  public void draw() {
    if (Input.pressKey('q') || Input.pressKey('x')) {
      Gather.instance.screen = new GameScreen();
    }
    
    background(20, 20, 60);

    Level.drawTiles();
      
    for (Entity entity : Level.entities) {
      entity.draw();
    }
    
    drawHud();
    
    fill(180, 120, 150, 90);
    rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    fill(200);
    textSize(32);
    text("PAUSED", 280, 224);
    textSize(20);
    text("PRESS Q OR X TO RESUME", 230, 260);
    Input.resetKeys();
  }
}

class WinScreen implements Screen {
  
  public void draw() {
    if (winTimer == 0) {
      System.exit(0);
    }
    else {
      winTimer--;
      
      background(20, 20, 60);
      Level.drawTiles();
      
      for (Entity entity : Level.entities) {
        entity.draw();
      }
      
      fill(190, 0, 255, 80);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      fill(255, 255, 255);
      textSize(26);
      text("Mission accomplished!", SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2);
    }
    Input.resetKeys();
  }
}

class DeathScreen implements Screen {
  
  public void draw() {
    if (Input.pressKey('z')) {
      Gather.instance.reset();
    }
    else {
      background(20, 20, 60);
      Level.drawTiles();
      
      for (Entity entity : Level.entities) {
        entity.draw();
      }
      
      fill(180, 20, 40, 80);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      fill(255, 255, 255);
      textSize(26);
      text("You have died.", SCREEN_WIDTH / 2 - 90, SCREEN_HEIGHT / 2 - 12);
      text("Press Z to try again.", SCREEN_WIDTH / 2 - 90, SCREEN_HEIGHT / 2 + 12);
    }
    Input.resetKeys();
  }
}