class Actor extends Entity {
  
  boolean goingUp, goingDown, goingLeft, goingRight;
  
  boolean facingRight;
  boolean onGround;
  
  float speed;
  float xVelocity;
  float yVelocity;
  
  int jumpTimer;
  int jumpMax;
  
  Actor() {
    speed = 1;
    onGround = false;
    facingRight = false;
  }
  
  boolean hasGravity() {
    return true;
  }
  
  void setVelocity() {
    xVelocity = 0;
    if (goingLeft) {
      xVelocity -= speed;
      if (!goingRight) {
        facingRight = false;
      }
    }
    if (goingRight) {
      xVelocity += speed;
      if (!goingLeft) {
        facingRight = true;
      }
    }
    
    if (hasGravity()) {
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
    else {
      yVelocity = 0;
      if (goingUp) {
        yVelocity -= speed;
      }
      if (goingDown) {
        yVelocity += speed;
      }
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