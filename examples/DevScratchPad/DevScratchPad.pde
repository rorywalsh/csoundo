/*
 * Developer scratch pad.  This isn't an example, just a place to try things.
 */
 
 import csoundo.*;

Csoundo cs;

void setup() {
    size(720, 480);
    noLoop();
 
    cs = new Csoundo(this, "DevScratchPad.csd");
    cs.run();
}

void draw() {
    background(0);
    println(cs.get0dBFS());
    println(cs.getOptions());
}
