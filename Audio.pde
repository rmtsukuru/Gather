import processing.sound.*;

static class Audio {
  
  static final boolean MUTE = false;
  static final float VOLUME = 0.5;
  
  static PApplet parent;
  
  static void configure(PApplet parent) {
    Audio.parent = parent;
  }
  
  static void play(String filename) {
    play(filename, false);
  }
  
  static void play(String filename, boolean loop) {
    if (!MUTE) {
      SoundFile file = new SoundFile(parent, "audio/" + filename);
      if (loop) {
        file.loop();
      }
      else {
        file.play();
      }
      file.amp(VOLUME);
    }
  }
}