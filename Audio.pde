import processing.sound.*;

static class Audio {
  
  static final boolean MUTE = false;
  
  static PApplet parent;
  
  static void configure(PApplet parent) {
    Audio.parent = parent;
  }
  
  static void play(String filename) {
    if (!MUTE) {
      SoundFile file = new SoundFile(parent, "audio/" + filename);
      file.play();
    }
  }
}