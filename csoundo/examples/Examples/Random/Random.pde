/*
 * Randomly generated visuals synchronized with audio.
 *
 * Example by Rory Walsh
 */

import csoundo.*;

Csoundo cs;
int cnt=0;
float x,y,amp;
boolean setup = false;


void setup() {
    size(displayWidth, displayHeight);
    //orientation(LANDSCAPE);
    background(0);
    frameRate(10);
    smooth();
    
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    //cs = new Csoundo(this, "Random.csd");
    cs.run();
    setup = true;
}

void draw() {
    x = random(width);
    y = random(height);
    amp = random(15000);

    cs.setChn("pitch", y);
    cs.setChn("pan", x/740);
    cs.setChn("amp", amp);
    

    
    fill(255, (x/800) * 255, 0, (y/480) * 255);
    ellipse(x,y, 20*(amp/2500), 20*(amp/2500)); 
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
