AccelerometerManager accel;
float ax, ay, az, pitch, amp;


import csoundo.*;

Csoundo cs;
int i, locked;
float rate;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(30);
  smooth();
  background(0);
  accel = new AccelerometerManager(this);
  orientation(PORTRAIT);
  noLoop();
  
  //Android Mode Only
  cs = new Csoundo(this, super.getApplicationContext());
  
  cs.run();

}


void draw() {
  fill(0, 32);
  rect(0, 0, width, height);  fill(255);
  textSize(70);
  textAlign(CENTER, CENTER);
  text("x: " + nf(ax, 1, 2) + "\n" + 
       "y: " + nf(ay, 1, 2) + "\n" + 
       "z: " + nf(az, 1, 2), 
       0, 0, width, height);
  pitch=map(ax, -10, 10, 400, 100);
  amp=map(ay, 10, -10, 0, 10000);
  if(!mousePressed){
    amp=0;
  }
  cs.setChn("pitch", pitch);
  cs.setChn("amp", amp);

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

public void resume() {
  if (accel != null) {
    accel.resume();
  }
}

    
public void pause() {
  if (accel != null) {
    accel.pause();
  }
}


public void shakeEvent(float force) {
  println("shake : " + force);

}


public void accelerationEvent(float x, float y, float z) {
//  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
 
  redraw();
}
