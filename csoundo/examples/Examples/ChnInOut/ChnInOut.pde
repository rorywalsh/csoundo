/*
 * Demonstrates writing data to a csound channel (chn) bus then reading
 * back the data. Move the mouse pointer around the screen.
 *
 * Example by Jacob Joaquin
 */

import csoundo.*;

Csoundo cs;

void setup() {
    size(740, 480);
    frameRate(30);
    smooth();

    //Android Mode (comment out either)
    //cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    cs = new Csoundo(this, "ChnInOut.csd");
    cs.run();
}

void draw() {
    background(0);
    
    // Send mouse position to Csound chn busses
    cs.setChn("mouse_x", mouseX / (float) width);
    cs.setChn("mouse_y", (1 - (mouseY / (float) height)));
    
    // Read chn busses
    float mx = cs.getChn("mouse_x");
    float my = cs.getChn("mouse_y");
    
    ellipseMode(RADIUS);
    fill(255, mx * 255, 0, my * 255);
    ellipse(width / 2.0, height / 2.0, 200, 200);
}
