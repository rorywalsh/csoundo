/*
 * Demonstrates running a Csound composition.
 * 
 * Message From Another Planet by Jacob Joaquin
 */

import csoundo.*;

Csoundo cs;

void setup() {
    size(740, 480);
    background(0);
    noLoop();
        
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    //cs = new Csoundo(this, "PlayMessage.csd");
    cs.run();
}

void draw() { }
