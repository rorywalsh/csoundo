/**
 * Based on Processing code from Keith Peters (www.bit-101.com). 
 * 
 * Example by Rory Walsh
 */

import csoundo.*;

Csoundo cs;

float[] x = new float[20];
float[] y = new float[20];
float segLength = 50;
float r, g, b;

void setup() {
    size(displayWidth, displayHeight);
    frameRate(10);
    smooth();
    stroke(0, 100);
    smooth();
    cs = new Csoundo(this, "SonicSock.csd");
    cs.run();
}

void draw() {
  background(1);
  dragSegment(0, mouseX, mouseY);
  for(int i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
  //send message to Csound  
  cs.setChn("mod", xin);
  cs.setChn("car", yin);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  r = random(255);
  g = random(255);
  b = random(255);
  stroke(r, g, b, 100);
  line(0, 0, segLength, 0);
  popMatrix();
}