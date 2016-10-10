import processing.sound.*;

static class Audio {
  
  static final boolean MUTE = false;
  static final float VOLUME = 0.5;
  
  static PApplet parent;
  
  static void configure(PApplet parent) {
    Audio.parent = parent;
  }
  
  static void play(String filename) {
    if (!MUTE) {
      SoundFile file = new SoundFile(parent, "audio/" + filename);
      file.play();
      file.amp(VOLUME);
    }
  }
}