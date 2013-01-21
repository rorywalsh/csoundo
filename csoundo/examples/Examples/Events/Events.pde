/*
 * Create i-events using the cs.event() method. For example:
 *     cs.event("i 2 0 0.25 0.4 880");
 * 
 * Example by Jacob Joaquin
 */

import csoundo.*;

Csoundo cs;
boolean enter = false;

void setup() {
    size(displayWidth, displayHeight);
    frameRate(30);
    smooth();
    background(0);
    noStroke();
    
    //Android Mode (comment out either)
    //cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    cs = new Csoundo(this, "Events.csd");
    cs.run();
}

void draw() {
    //background(0, 64);
    fill(0, 32);
    rect(0, 0, width, height);
    
    // Trigger note once per second
    if (frameCount % 30 == 0) {
        cs.event("i 2 0 1 0.4 440");
    }

    // Trigger note 6 times per second when mouse is in blue circle
    float xpos = width * 0.333;
    float ypos = height * 0.5;
    float r = 150;
    
    if (dist(mouseY, mouseX, ypos, xpos) < r) {
        if (frameCount % 5 == 0) {
           cs.event("i 2 0 0.25 0.4 880");
        }
        
        fill(0, 0, 255, 128);
    } else {
        fill(0, 0, 255, 64);
    }

    ellipseMode(RADIUS);
    ellipse(xpos, ypos, r, r);

    // Turn on note when mouse is in red circle, turn off after exit
    xpos = xpos+200;//width * 0.666;
    ypos = height * 0.5;
    
    if (dist(mouseY, mouseX, ypos, xpos) < r) {
        if (enter == false) {
           cs.event("i 4 0 -1 0.3 220");  // Turn on instr 4 indefintely
           enter = true;
        }
        
        fill(255, 0, 0, 128);
    } else {
        if (enter == true) {
            cs.event("i 3 0 1");  // Turn off instr 4
            enter = false;
        }
        
        fill(255, 0, 0, 64);
    }

    ellipseMode(RADIUS);
    ellipse(xpos, ypos, r, r);        
}
