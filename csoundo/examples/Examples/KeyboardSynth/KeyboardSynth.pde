/*************************/
/* Simple Keyboard Synth */
/*************************/

//import Csoundo, controlP5
import csoundo.*;
import controlP5.*;

//Csoundo and ControlP5 objects
Csoundo cs;
ControlP5 cp5;

void setup() {
  //Android Mode
  cs = new Csoundo(this, super.getApplicationContext());
  //Java Mode
  //cs = new Csoundo(this, "KeyboardSynth.csd");    
  cs.run();  
  
  size(displayWidth,displayHeight);
  //size(500, 300);
  noStroke();
  cp5 = new ControlP5(this);

  int whiteKeyWidth = width/7;
  int whiteKeyHeight = (int)(height-(height*.2));
  int keyYPos = height-whiteKeyHeight;
  int blackKeyOffset = int(whiteKeyWidth*.7);
  int blackKeyWidth = int(whiteKeyWidth*.6);
  int blackKeyHeight = int(whiteKeyHeight*.6);
  
  cp5.addSlider("harmonics").setMin(1).setMax(10).setSize(displayWidth-20, 40).setPosition(5, 10);
  
//whitekeys
  cp5.addButton("C").setValue(0).setPosition(0,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                        .setColorActive(color(100)).setColorForeground(color(255)).setColorBackground(color(255));  
  cp5.addButton("D").setValue(.02).setPosition(whiteKeyWidth,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false).
                        setColorForeground(color(255)).setColorBackground(color(255));
  cp5.addButton("E").setValue(.04).setPosition(whiteKeyWidth*2,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                        .setColorForeground(color(255)).setColorBackground(color(255));
  cp5.addButton("F").setValue(.05).setPosition(whiteKeyWidth*3,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(255)).setColorBackground(color(255));
  cp5.addButton("G").setValue(.07).setPosition(whiteKeyWidth*4,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(255)).setColorBackground(color(255));
  cp5.addButton("A").setValue(.09).setPosition(whiteKeyWidth*5,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(255)).setColorBackground(color(255));
  cp5.addButton("B").setValue(.11).setPosition(whiteKeyWidth*6,keyYPos).setSize(whiteKeyWidth-2,whiteKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(255)).setColorBackground(color(255));

//black keys
  cp5.addButton("C#").setValue(.01).setPosition(0+blackKeyOffset,keyYPos).setSize(blackKeyWidth-2,blackKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(0)).setColorBackground(color(1));
  cp5.addButton("D#").setValue(.03).setPosition(whiteKeyWidth+blackKeyOffset,keyYPos).setSize(blackKeyWidth-2,blackKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(0)).setColorBackground(color(1));
  cp5.addButton("F#").setValue(.06).setPosition(whiteKeyWidth*3+blackKeyOffset,keyYPos).setSize(blackKeyWidth-2,blackKeyHeight).setLabelVisible(false).
                          setColorForeground(color(0)).setColorBackground(color(1));
  cp5.addButton("G#").setValue(.08).setPosition(whiteKeyWidth*4+blackKeyOffset, keyYPos).setSize(blackKeyWidth-2,blackKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(0)).setColorBackground(color(1));
  cp5.addButton("A#").setValue(.10).setPosition(whiteKeyWidth*5+blackKeyOffset,keyYPos).setSize(blackKeyWidth-2,blackKeyHeight).setLabelVisible(false)
                          .setColorForeground(color(0)).setColorBackground(color(1));
 
}

void draw() {
  background(140);
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName()+":"+theEvent.getController().getValue());
  if(theEvent.getController().getName()!="harmonics")
  cs.setChn("freq", theEvent.getController().getValue()+8);
  else if(theEvent.getController().getName()=="harmonics")
  cs.setChn("hrms", theEvent.getController().getValue());

}



/*
a list of all methods available for the Button Controller
use ControlP5.printPublicMethodsFor(Button.class);
to print the following list into the console.

You can find further details about class Button in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Button : Button activateBy(int) 
controlP5.Button : Button setOff() 
controlP5.Button : Button setOn() 
controlP5.Button : Button setSwitch(boolean) 
controlP5.Button : Button setValue(float) 
controlP5.Button : Button update() 
controlP5.Button : String getInfo() 
controlP5.Button : String toString() 
controlP5.Button : boolean getBooleanValue() 
controlP5.Button : boolean isOn() 
controlP5.Button : boolean isPressed() 
controlP5.Controller : Button addCallback(CallbackListener) 
controlP5.Controller : Button addListener(ControlListener) 
controlP5.Controller : Button bringToFront() 
controlP5.Controller : Button bringToFront(ControllerInterface) 
controlP5.Controller : Button hide() 
controlP5.Controller : Button linebreak() 
controlP5.Controller : Button listen(boolean) 
controlP5.Controller : Button lock() 
controlP5.Controller : Button plugTo(Object) 
controlP5.Controller : Button plugTo(Object, String) 
controlP5.Controller : Button plugTo(Object[]) 
controlP5.Controller : Button plugTo(Object[], String) 
controlP5.Controller : Button registerProperty(String) 
controlP5.Controller : Button registerProperty(String, String) 
controlP5.Controller : Button registerTooltip(String) 
controlP5.Controller : Button removeBehavior() 
controlP5.Controller : Button removeCallback() 
controlP5.Controller : Button removeCallback(CallbackListener) 
controlP5.Controller : Button removeListener(ControlListener) 
controlP5.Controller : Button removeProperty(String) 
controlP5.Controller : Button removeProperty(String, String) 
controlP5.Controller : Button setArrayValue(float[]) 
controlP5.Controller : Button setArrayValue(int, float) 
controlP5.Controller : Button setBehavior(ControlBehavior) 
controlP5.Controller : Button setBroadcast(boolean) 
controlP5.Controller : Button setCaptionLabel(String) 
controlP5.Controller : Button setColor(CColor) 
controlP5.Controller : Button setColorActive(int) 
controlP5.Controller : Button setColorBackground(int) 
controlP5.Controller : Button setColorCaptionLabel(int) 
controlP5.Controller : Button setColorForeground(int) 
controlP5.Controller : Button setColorValueLabel(int) 
controlP5.Controller : Button setDecimalPrecision(int) 
controlP5.Controller : Button setDefaultValue(float) 
controlP5.Controller : Button setHeight(int) 
controlP5.Controller : Button setId(int) 
controlP5.Controller : Button setImages(PImage, PImage, PImage) 
controlP5.Controller : Button setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : Button setLabelVisible(boolean) 
controlP5.Controller : Button setLock(boolean) 
controlP5.Controller : Button setMax(float) 
controlP5.Controller : Button setMin(float) 
controlP5.Controller : Button setMouseOver(boolean) 
controlP5.Controller : Button setMoveable(boolean) 
controlP5.Controller : Button setPosition(PVector) 
controlP5.Controller : Button setPosition(float, float) 
controlP5.Controller : Button setSize(PImage) 
controlP5.Controller : Button setSize(int, int) 
controlP5.Controller : Button setStringValue(String) 
controlP5.Controller : Button setUpdate(boolean) 
controlP5.Controller : Button setValueLabel(String) 
controlP5.Controller : Button setView(ControllerView) 
controlP5.Controller : Button setVisible(boolean) 
controlP5.Controller : Button setWidth(int) 
controlP5.Controller : Button show() 
controlP5.Controller : Button unlock() 
controlP5.Controller : Button unplugFrom(Object) 
controlP5.Controller : Button unplugFrom(Object[]) 
controlP5.Controller : Button unregisterTooltip() 
controlP5.Controller : Button update() 
controlP5.Controller : Button updateSize() 
controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : PImage setImage(PImage) 
controlP5.Controller : PImage setImage(PImage, int) 
controlP5.Controller : PVector getAbsolutePosition() 
controlP5.Controller : PVector getPosition() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 


*/



