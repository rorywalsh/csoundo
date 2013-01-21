/**
 * Continuous Lines. 
 * 
 * Click and drag the mouse to draw a line. 
 */
import csoundo.*;

Csoundo cs;

float[] points;
float prevY = height/2;
float prevX = 0;
int tableNumber = 1;
int tableLength = 1024;


void setup() {
  //Android Mode (comment out either)
  //cs = new Csoundo(this, super.getApplicationContext());
  //Java Mode
  cs = new Csoundo(this, "DrawWaveform.csd");
  cs.run();
  points = new float[1024];
  for(int i=0;i<1024;i++)
  points[i]=0;
  size(640, 360);
  background(255);
  fillPointsArray();
  drawPoints();
  noLoop();
  
}

void draw() {
  background(255);
  fill(255);
  rect(0, 0, width, height);
  drawPoints();
}

void mouseDragged(){
 float index = (float(mouseX)/float(width))*tableLength;
 float amp = (float(mouseY)/float(height)*-2)+1;
 if(index>5 && index<(tableLength-5)){
 points[int(index)-1] = amp;
 cs.tableSet(1, int(index)-1, amp); 
 points[int(index)-2] = amp;
 cs.tableSet(1, int(index)-2, amp);
 points[int(index)-3] = amp;
 cs.tableSet(1, int(index)-3, amp);
 points[int(index)-4] = amp;
 cs.tableSet(1, int(index)-4, amp);
 points[int(index)] = amp;
 cs.tableSet(1, int(index), amp);
 points[int(index)+1] = amp;
 cs.tableSet(1, int(index)+1, amp);
 points[int(index)+2] = amp;
 cs.tableSet(1, int(index)+2, amp);
 points[int(index)+3] = amp;
 cs.tableSet(1, int(index)+3, amp);
 points[int(index)+4] = amp;
 cs.tableSet(1, int(index)+4, amp);
 }
 redraw();
}

void fillPointsArray() {
 for(int i=0;i<tableLength;i++)
      points[i] = cs.tableGet(tableNumber, i);
}

void drawPoints(){
  strokeWeight(1);
  //fill(255, 0, 0);
  float amp;
  float index;
  for(int i = 0; i < tableLength; i++)
    {
    amp = height-(((points[i]+1)/2)*height);
    index = (float(i)/float(tableLength))*width;
    line(prevX, prevY, index, amp);
    prevX = index;
    prevY = amp;
    }   
}


