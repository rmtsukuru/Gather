boolean isKey(char keyName) {
  return key != CODED && key == keyName;
}

boolean isKey(int code) {
  return key == CODED && keyCode == code;
}

void keyPressed() {
  if (isKey(UP)) {
    player.goingUp = true;
  }
  else if (isKey(DOWN)) {
    player.goingDown = true;
  }
  else if (isKey(LEFT)) {
    player.goingLeft = true;
  }
  else if (isKey(RIGHT)) {
    player.goingRight = true;
  }
  else if (isKey(' ')) {
    player.goingUp = true;
  }
}

void keyReleased() {
  if (isKey(UP)) {
    player.goingUp = false;
  }
  else if (isKey(DOWN)) {
    player.goingDown = false;
  }
  else if (isKey(LEFT)) {
    player.goingLeft = false;
  }
  else if (isKey(RIGHT)) {
    player.goingRight = false;
  }
  else if (isKey(' ')) {
    player.goingUp = false;
  }
}