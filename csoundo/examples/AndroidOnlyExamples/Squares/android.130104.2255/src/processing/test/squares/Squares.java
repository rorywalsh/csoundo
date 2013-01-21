package processing.test.squares;

import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import csoundo.*; 

import android.view.MotionEvent; 
import android.view.KeyEvent; 
import android.graphics.Bitmap; 
import java.io.*; 
import java.util.*; 

public class Squares extends PApplet {

/*
 * Rotating squares which affect rate of frequency modulation
 *
 * Example by Conor Robotham
 * Multi-touch adapted from Eric Pavey's Multitouch.pde
 */



Csoundo cs;
Square[] squares;

// Define max touch events.(Must not be more than Csound instr available)
int maxTouchEvents = 4;
// This array will hold all of our queryable MultiTouch data:
MultiTouch[] mt;         


public void setup() {
 
  orientation(LANDSCAPE);
  background(0);
  frameRate(30);
  smooth();
  
  //Android Mode (comment out either)
  cs = new Csoundo(this, super.getApplicationContext());
  //Java Mode
  //cs = new Csoundo(this, "Squares.csd");
  
  cs.run();
  
  squares= new Square[maxTouchEvents];
  for (int i = 0; i < maxTouchEvents; i++) {
    squares[i] = new Square(i, cs); // Create each object
  }
  
  
  // Populate our MultiTouch array that will track all of our touch-points:
  mt = new MultiTouch[maxTouchEvents];
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i] = new MultiTouch();
  }
}

public void draw() {
  
  fill(0, 20);
  rect(0, 0, displayWidth, displayHeight);
  
  // If the screen is touched, start querying for MultiTouch events:
  if(mousePressed){
    // ...for each possible touch event...
    for(int i=0; i < maxTouchEvents; i++) {
    
      squares[i].update(mt[i].motionX, mt[i].motionY);
      squares[i].display();      
    }
  }
  

  for(int i=0; i < maxTouchEvents; i++) {
    if(i!=0){
    squares[i].toggle(mt[i].touched);
    }
  }
  //first touch on/off must be determined with mousePressed
  squares[0].toggle(mousePressed);
  
}


class Square
{
  int squareSize, squareNum, instr, toggle=0;
  float speed=0, angle=0, rate=1, x, y;
  
  Square(int squareNumIn, Csoundo cs){
   
    squareNum=squareNumIn;
    instr=squareNum+1;
  }
  
  public void update(float ix, float iy){
    
      x= ix;
      y= iy;
      rate=map(x, 0, displayWidth, 1, 20);
      cs.setChn("rate"+instr, rate);

  }
  
  public void toggle(boolean iToggle){
    //toggle must be an int for cs.setChn
      if(iToggle){
        toggle=1;
      }
      else{
        toggle=0;
      }
      cs.setChn("toggle"+instr, toggle);
    
  }
    
  public void display(){
     noStroke();
     squareSize=(displayWidth/10);
     speed=map(x, 0, displayWidth, 0.195f, 2);
     angle+=speed;
     
     switch(squareNum+1){
       case 1:fill(20, 20, 200, 200);
       break;
       case 2:fill(200, 20, 20, 200);
       break;
       case 3:fill(20, 200, 20, 200);
       break;
       default:fill(200, 200, 20, 200);
       break;
     }
          
      if(toggle==1){
        pushMatrix();
        translate(x, y);
        rotate(angle);
        rect(0,0, squareSize, squareSize);
        popMatrix();
      }
  }
}

//------------------------------
// Override parent class's surfaceTouchEvent() method to enable multi-touch.
// This is what grabs the Android multitouch data, and feeds our MultiTouch
// classes.  Only executes on touch change (movement across screen, or initial
// touch).

public boolean surfaceTouchEvent(MotionEvent me) {
  // Find number of touch points:
  int pointers = me.getPointerCount();
  // Set all MultiTouch data to "not touched":
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i].touched = false;
  }
  //  Update MultiTouch that 'is touched':
  for(int i=0; i < maxTouchEvents; i++) {
    if(i < pointers) {
      mt[i].update(me, i);
    }
    // Update MultiTouch that 'isn't touched':
    else {
      mt[i].update();
    }
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(me);
}

//------------------------------
// Class to store our multitouch data per touch event.

class MultiTouch {
  // Public attrs that can be queried for each touch point:
  float motionX, motionY;
  float pmotionX, pmotionY;
  float size, psize;
  int id;
  boolean touched = false;

  // Executed when this index has been touched:
  //void update(MotionEvent me, int index, int newId){
  public void update(MotionEvent me, int index) {
    // me : The passed in MotionEvent being queried
    // index : the index of the item being queried
    // newId : The id of the pressed item.

    // Tried querying these via' the 'historical' methods,
    // but couldn't get consistent results.
    pmotionX = motionX;
    pmotionY = motionY;
    psize = size; 

    motionX = me.getX(index);
    motionY = me.getY(index);
    size = me.getSize(index);

    id = me.getPointerId(index);
    touched = true;
  }

  // Executed if this index hasn't been touched:
  public void update() {
    pmotionX = motionX;
    pmotionY = motionY;
    psize = size;
    touched = false;
  }
}


  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
}
