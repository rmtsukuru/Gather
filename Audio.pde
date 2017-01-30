import processing.sound.*;
import ddf.minim.*;

static class Audio {
  
  static final boolean MUTE = false;
  static final boolean MUTE_BGM = false;
  static final float VOLUME = 0.5;
  
  static PApplet parent;
  
  static Minim minim;
  static AudioPlayer player;
  
  static void configure(PApplet parent) {
    Audio.parent = parent;
    minim = new Minim(parent);
  }
  
  static void resetPlayer() {
    if (player != null) {
      player.pause();
    }
  }
  
  static void play(String filename) {
    play(filename, false);
  }
  
  static void play(String filename, boolean loop) {
    if (!MUTE) {
      if (loop) {
        if (!MUTE_BGM) {
          resetPlayer();
          player = minim.loadFile("audio/" + filename);
          player.loop();
          player.setVolume(VOLUME);
        }
      }
      else {
        SoundFile file = new SoundFile(parent, "audio/" + filename);
        file.play();
        file.amp(VOLUME);
      }
    }
  }
}