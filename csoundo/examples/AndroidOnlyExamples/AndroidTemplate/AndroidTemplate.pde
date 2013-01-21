/*
 * AndroidTemplate.
 */
 
import csoundo.*;

Csoundo cs;

void setup() {
  
    //Android Mode (comment out either)
    cs = new Csoundo(this, super.getApplicationContext());
    cs.run();
    
}

void draw() {
    background(0);
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
