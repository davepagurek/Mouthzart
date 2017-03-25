import beads.*;
import org.jaudiolibs.beads.*;

import jm.JMC;
import jm.music.data.*;
import jm.music.tools.*;
import jm.util.*;
import java.util.Vector;
import java.util.Collections;
import java.util.LinkedList;
import java.awt.event.*;
import java.awt.*;
import java.util.Enumeration;

AudioContext context;
Gain g;

Vector<Sample> samples;
int syllable = 0;

LinkedList<NoteEvent> events;

void setup() {
  context = new AudioContext();
  g = new Gain(context, 1, 0.5);
  context.out.addInput(g);
  context.start();

  samples = new Vector<Sample>();
  for (int i = 1; i <= 13; i++) {
    try {
      Sample song = new Sample(String.format("/Users/dpagurek/Documents/Projects/Mouthzart/allstar/%03d.wav", i));
      samples.add(song);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  events = new LinkedList<NoteEvent>();
  //out = minim.getLineOut();

  Score s = new Score();
  Read.midi(s, "/Users/dpagurek/Documents/Projects/Mouthzart/elise.mid");

  int tempLength = 0;
  // iterate through each note
  //find the highest and lowest notes    
  for (Part part : (Vector<Part>)s.getPartList()) {
    for (Phrase phrase : (Vector<Phrase>)part.getPhraseList()) {
      double offset = phrase.getStartTime();
      for (Note note : (Vector<Note>)phrase.getNoteList()) {
        int pitch = note.getPitch();
        while (pitch < 50) pitch += 12;
        while (pitch > 90) pitch -= 12;
        offset += note.getOffset();
        //println(pitch + " at " + (offset*(60.0*1000.0/s.getTempo())) + " with offset " + note.getOffset());
        if (!note.isRest()) {
          //samples.get(syllable).cue((int)(offset*(60.0*1000.0/s.getTempo())));
          //samples.get(syllable).cue(0);
          events.add(new NoteEvent(pitch, offset*(32000.0/s.getTempo()), syllable));
          syllable = (syllable+1) % samples.size();
        }
        offset += note.getDuration();
      }
    }
  }

  Collections.sort(events);
}

double time;
void draw() {
  background(0);
  while (events.peek() != null && events.peek().time <= frameCount*(1000.0/(double)frameRate)) {
    //println(events.pop().time);
    events.pop().play(g, context, samples);
  }
}
