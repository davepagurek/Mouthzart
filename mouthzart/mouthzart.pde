import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import jm.JMC;
import jm.music.data.*;
import jm.music.tools.*;
import jm.util.*;
import java.util.Vector;
import java.awt.event.*;
import java.awt.*;
import java.util.Enumeration;

void setup() {
  Score s = new Score();
  Read.midi(s, "/Users/dpagurek/Documents/Projects/Mouthzart/elise.mid");

  int tempLength = 0;
  // iterate through each note
  //find the highest and lowest notes    
  for (Part part : (Vector<Part>)s.getPartList()) {
    for (Phrase phrase : (Vector<Phrase>)part.getPhraseList()) {
      for (Note note : (Vector<Note>)phrase.getNoteList()) {
        int pitch = note.getPitch();
        double rv = note.getRhythmValue();
        print(pitch + ": " + rv + "\n");
      }
    }
  }
}
