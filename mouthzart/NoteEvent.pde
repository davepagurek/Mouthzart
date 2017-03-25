class NoteEvent implements Comparable<NoteEvent> {
  public int pitch;
  public double time;
  public int syllable;

  public NoteEvent(int pitch, double time, int syllable) {
    this.pitch = pitch;
    this.time = time;
    this.syllable = syllable;
  }

  public void play(Gain g, AudioContext context, Vector<Sample> samples) {
    SamplePlayer player = new SamplePlayer(context, samples.get(syllable));
    float pitchRatio = pow(2,(pitch-72)/12.0);
    player.setRate(new Glide(context, pitchRatio));
    player.setKillOnEnd(true);
    g.addInput(player);
    player.start();
  }

  public int compareTo(NoteEvent other) {
    return Double.compare(time, other.time);
  }
}
