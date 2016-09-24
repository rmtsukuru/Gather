class KeyState {
  boolean beingHeld, pressed, released;
  
  KeyState() {
    beingHeld = false;
    pressed = false;
    released = false;
  }
}

ArrayList<Object> keys = new ArrayList();
HashMap<Object, KeyState> keyState = new HashMap();

void configureInput() {
  keys.add('z');
  keys.add(' ');
  keys.add(UP);
  keys.add(DOWN);
  keys.add(LEFT);
  keys.add(RIGHT);
  
  for (Object k : keys) {
    keyState.put(k, new KeyState());
  }
}

boolean isKey(Object keyName) {
  if (keyName instanceof Integer) {
    return isKey((int) keyName);
  }
  return isKey((char) keyName);
}

boolean isKey(char keyName) {
  return key != CODED && key == keyName;
}

boolean isKey(int code) {
  return key == CODED && keyCode == code;
}

void resetKeys() {
  for (Object k : keys) {
    KeyState state = keyState.get(k);
    
    state.pressed = false;
    state.released = false;
  }
}

void keyPressed() {
  for (Object k : keys) {
    if (isKey(k)) {
      KeyState state = keyState.get(k);
      
      state.pressed = true;
      state.beingHeld = true;
    }
  }
}

void keyReleased() {
  for (Object k : keys) {
    if (isKey(k)) {
      KeyState state = keyState.get(k);
      
      state.released = true;
      state.beingHeld = false;
    }
  }
}