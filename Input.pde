void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      player.goingUp = true;
    }
    else if (keyCode == DOWN) {
      player.goingDown = true;
    }
    else if (keyCode == LEFT) {
      player.goingLeft = true;
    }
    else if (keyCode == RIGHT) {
      player.goingRight = true;
    }
  }
  else {
    if (key == ' ') {
      player.goingUp = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      player.goingUp = false;
    }
    else if (keyCode == DOWN) {
      player.goingDown = false;
    }
    else if (keyCode == LEFT) {
      player.goingLeft = false;
    }
    else if (keyCode == RIGHT) {
      player.goingRight = false;
    }
  }
  else {
    if (key == ' ') {
      player.goingUp = false;
    }
  }
}