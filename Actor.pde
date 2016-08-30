class Actor extends Entity {
  
  boolean goingUp, goingDown, goingLeft, goingRight;
  
  boolean onGround;
  
  float speed;
  float xVelocity;
  float yVelocity;
  
  int jumpTimer;
  int jumpMax;
  
  Actor() {
    speed = 1;
    onGround = false;
  }
  
  void setVelocity() {
    
    xVelocity = 0;
    if (goingLeft) {
      xVelocity -= speed;
    }
    if (goingRight) {
      xVelocity += speed;
    }
    
    if (goingUp && onGround) {
      onGround = false;
      jumpTimer = jumpMax;
    }
    
    if (jumpTimer > 0 && !onGround && goingUp) {
      jumpTimer--;
      applyGravity(false);
    }
    else {
      jumpTimer = 0;
      applyGravity();
    }
  }
  
  void applyGravity() {
    applyGravity(true);
  }
  
  void applyGravity(boolean down) {
    if (down) {
      onGround = false;
      if (yVelocity < speed * 2) {
        yVelocity += speed / 10;
      }
    }
    else {
      if (yVelocity > speed * -2) {
        yVelocity -= speed / 5;
      }
    }
  }
  
  void update() {
    setVelocity();
    x += xVelocity;
    y += yVelocity;
  }
}