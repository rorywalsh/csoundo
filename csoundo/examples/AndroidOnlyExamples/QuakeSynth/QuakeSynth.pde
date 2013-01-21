/*
 * Randomly generated visuals synchronized with audio.
 *
 * Example by Rory Walsh
 */

import csoundo.*;
import android.os.Vibrator;

Csoundo cs;
int cnt=0;
float x,y,amp;
boolean setup = false;
long[] pattern = {0, 50, 950, 50, 950, 50, 950, 100, 400, 
                     100, 400, 100, 400, 150, 183, 150, 183,
                     225, 25, 225, 25, 225, 25, 225, 25
                 };
Vibrator v;
boolean locked=false;
int counter=0, grow=0, red=0;


void setup() {
    size(displayWidth, displayHeight);
    //orientation(LANDSCAPE);
    background(0);
    frameRate(30);
    smooth();
    
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    //cs = new Csoundo(this, "QuakeSynth.csd");
    cs.run();
    setup = true;
    // Get instance of Vibrator from current Context
    v = (Vibrator) getSystemService(super.VIBRATOR_SERVICE);

}

void draw() {
 
    if (mousePressed){
      if(!locked){
        v.vibrate(pattern, 18);
        cs.setChn("rate", 1);
        cs.setChn("toggle", 1);
        locked=true;
        grow=0;
        red=0;
      }
      counter++;
      if(counter==90){
        cs.setChn("rate", 2);
        grow=40;
        red=100;
      }
      if(counter==135){
        cs.setChn("rate", 3);
        grow=130;
        red=180;
      }
      if(counter==165){
        cs.setChn("rate", 4);
        grow=200;
        red=240;
      }
      
      fill(255, 255-red, 255-red, 255);
      ellipse(mouseX, mouseY, 100+grow, 100+grow);
      fill(0 , 0, 0, 255);
      ellipse(mouseX, mouseY, 80+grow, 80+grow); 
    }
    
    if(!mousePressed){
      locked=false;
      v.cancel();
      cs.setChn("toggle", 0);
      counter=0;
    }
    
    fill(0, 0, 0, 10);
    rect(0, 0, width, height);
}

@Override
public void onPause() {
    super.onPause();  // Always call the superclass method first
    if(setup){
      cs.pause();
    }
}

@Override
public void onResume() {
    super.onResume();  // Always call the superclass method first
    if(setup){
      cs.resume();
    }
}
