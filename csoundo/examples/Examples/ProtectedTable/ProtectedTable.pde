/*
 * Not an example, but a test to make sure table data is protected.
 * 
 * Every frame, a new Csound table is generated, overwriting the existing
 * table. Each value is replaced with a sine + noise value, and then read
 * from the table and used for drawing an animation.
 *
 * Some indicators that the test fails at times, where it reads a value
 * before it has been properly set. Watch the zero line. Pay attention
 * or you'll miss it.
 *
 * !Example by Jacob Joaquin
 */

import csoundo.*;

Csoundo cs;
int bugs = 0;

void setup() {
    size(740, 480);
    frameRate(30);
    smooth();

    ellipseMode(RADIUS);
    background(0);    
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    //cs = new Csoundo(this, "ProtectedTable.csd");
    cs.run();
}

void draw() {
    noStroke();
    fill(0, 8);
    rect(0, 0, width, height);
    
    // Create empty table    
    float size = pow(2, 12);
    cs.event("f 20 0 " + size + " 10 0");
    int length = cs.tableLength(20);
    
    // Increment phase of sine table input
    int inc = 60;
    float phase = (float) (frameCount % inc) / inc * TWO_PI;
    
    // Create, write, read and draw sine waveform 
    stroke(255, 255);
    beginShape();

    for (int i = length - 1; i >= 0; i--) {
    
        // Generate sine data point and input into table
        float input = sin(TWO_PI * (float) i / (float) length + phase);
        cs.tableSet(20, length, input);

        // Read the from the table at the same index
        float output = cs.tableGet(20, length);
        
        // Print message if input != output
        if (output != input) {
            println(output + " != " + input + " @index " + i);
            bugs++;
            println("fail rate = " + ((float) bugs / (float) frameCount));
        }

        // Draw wave form
        vertex((float) i / (float) (length - 1) * (float) width,
               height / 2.0 + height / 2.0 * output);
        
    }
    
    endShape();
}
