/*
 * Demonstrates reading values from an f-table and how to format f-tables
 * into nice looking graphics. Perfect for the class room, papers and blogs.
 *
 * This example can be modified to output scalable vector graphics (SVG)
 * to use in programs such as illustrator. See the PDF Library for details.
 * 
 * Example by Jacob Joaquin
 */


import csoundo.*;

Csoundo cs;

void setup() {
    size(720, 480);
    smooth();
    noLoop();
    
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    //cs = new Csoundo(this, "DrawTables.csd");
    cs.run();
}

void draw() {
    background(255);

    displayTable(1, 20, height * 0.25, width - 40, height * 0.20);
    displayDiscreteTable(2, 20, height * 0.75, width - 40, height * 0.20);
}

void displayDiscreteTable(int t, float x, float y, float w, float h) {
    int length = cs.tableLength(t);        

    stroke(0);
    strokeWeight(1);
    line(x, y, x + w, y);
    
    for (int i = 0; i < length; i++) {
        float xpos = x + (float) i / (float) (length - 1) * w;
        float ypos = y + (cs.tableGet(t, i) * -1) * h;
        line(xpos, y, xpos, ypos);
    }

    for (int i = 0; i < length; i++) {
        float xpos = x + (float) i / (float) (length - 1) * w;
        float ypos = y + (cs.tableGet(t, i) * -1) * h;        
        fill(0);
        noStroke();
        ellipseMode(RADIUS);
        ellipse(xpos, ypos, 3, 3);
    }
}

void displayTable(int t, float x, float y, float w, float h) {
    int length = cs.tableLength(t);    

    stroke(0);
    strokeWeight(1);
    noFill();
    line(x, y, x + w, y);

    beginShape();    
    for (int i = 0; i < length; i++) {
        float v = cs.tableGet(t, i);
        float xpos = x + (float) i / (float) (length - 1) * w;
        float ypos = y + (v * -1) * h;
        
        vertex(xpos, ypos);
    }    
    endShape();
}
