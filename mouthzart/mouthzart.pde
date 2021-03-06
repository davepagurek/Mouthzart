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
import java.util.ListIterator;

AudioContext context;
Gain g;

Vector<Sample> samples;
int syllable = 0;

LinkedList<NoteEvent> events;
LinkedList<Shrek> shreks;
PImage shrek;

void setup() {
  size(320, 180);
  shrek = loadImage("Shrek_emoji.png");
  shreks = new LinkedList<Shrek>();
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
  Read.midi(s, "/Users/dpagurek/Documents/Projects/Mouthzart/beethoven-fur-elise.mid");
  println(s.getTempo());

  int tempLength = 0;
  // iterate through each note
  //find the highest and lowest notes    
  for (Part part : (Vector<Part>)s.getPartList()) {
    for (Phrase phrase : (Vector<Phrase>)part.getPhraseList()) {
      double offset = phrase.getStartTime();
      syllable = 0;
      for (Note note : (Vector<Note>)phrase.getNoteList()) {
        int pitch = note.getPitch();
        while (pitch < 50) pitch += 12;
        while (pitch > 90) pitch -= 12;
        offset += note.getOffset();
        //println(pitch + " at " + (offset*(60.0*1000.0/s.getTempo())) + " with offset " + note.getOffset());
        if (!note.isRest()) {
          //samples.get(syllable).cue((int)(offset*(60.0*1000.0/s.getTempo())));
          //samples.get(syllable).cue(0);
          for (double i=0; i<note.getDuration(); i+=0.25) {
            events.add(new NoteEvent(pitch, (offset+i)*(60000.0/(double)(15+s.getTempo())), syllable));
            syllable = (syllable+1) % samples.size();
          }
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
  int added = 0;
  while (events.peek() != null && events.peek().time <= (double)frameCount*(1000.0/(double)frameRate)) {
    //println(events.pop().time);
    events.pop().play(g, context, samples);
    added++;
    if (added <= 1) {
      shreks.add(new Shrek(random(0,width), random(0,height)));
    }
  }

  ListIterator<Shrek> it = shreks.listIterator();
  while (it.hasNext()) {
    Shrek s = it.next();
    s.tick();
    if (s.done()) {
      it.remove();
    } else {
      s.draw();
    }
  }
}
