static class Input {

  static class KeyState {
    boolean beingHeld, pressed, released;
  
    KeyState() {
      beingHeld = false;
      pressed = false;
      released = false;
    }
  }
  
  static PApplet parent;

  static ArrayList<Object> keys = new ArrayList();
  static HashMap<Object, KeyState> keyState = new HashMap();

  static void configure(PApplet parent) {
    Input.parent = parent;
    
    keys.add('z');
    keys.add('x');
    keys.add(' ');
    keys.add(UP);
    keys.add(DOWN);
    keys.add(LEFT);
    keys.add(RIGHT);
  
    for (Object k : keys) {
      keyState.put(k, new KeyState());
    }
  }

  static boolean isKey(Object key) {
    if (key instanceof Integer) {
      return isKey((int) key);
    }
    return isKey((char) key);
  }
  
  static boolean isKey(char key) {
    return parent.key != CODED && parent.key == key;
  }
  
  static boolean isKey(int key) {
    return parent.key == CODED && parent.keyCode == key;
  }
  
  static boolean holdKey(Object key) {
    return keyState.get(key).beingHeld;
  }
  
  static boolean pressKey(Object key) {
    return keyState.get(key).pressed;
  }
  
  static boolean releaseKey(Object key) {
    return keyState.get(key).released;
  }
  
  static void resetKeys() {
    for (Object k : keys) {
      KeyState state = keyState.get(k);
      
      state.pressed = false;
      state.released = false;
    }
  }
  
  static void keyPressed() {
    for (Object k : keys) {
      if (isKey(k)) {
        KeyState state = keyState.get(k);
        
        if (!state.beingHeld) {
          state.pressed = true;
        }
        state.beingHeld = true;
      }
    }
  }
  
  static void keyReleased() {
    for (Object k : keys) {
      if (isKey(k)) {
        KeyState state = keyState.get(k);
        
        state.released = true;
        state.beingHeld = false;
      }
    }
  }
}

void keyPressed() {
  Input.keyPressed();
}

void keyReleased() {
  Input.keyReleased();
}