class Actor extends Entity {
  
  boolean goingUp, goingDown, goingLeft, goingRight;
  
  boolean facingRight;
  boolean onGround;
  boolean jumping;
  
  float speed;
  float xVelocity;
  float yVelocity;
  
  int jumpTimer;
  int jumpMax;
  
  Actor() {
    this(0, 0);
  }
  
  Actor(float x, float y) {
    super(x, y);
    speed = 1;
    
    facingRight = false;
    onGround = false;
    jumping = false;
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
      if (jumping && onGround) {
        onGround = false;
        jumpTimer = jumpMax;
      }
      
      if (jumpTimer > 0 && !onGround && jumping) {
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
  
  void handleTileCollision() {
    // Do nothing, this is for overriding.
  }
  
  void handleEntityCollision(Entity other) {
    // Do nothing, this is also for overriding.
  }
}