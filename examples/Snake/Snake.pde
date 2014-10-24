//=================================================
//initialise and declare variables
//
// THIS FILE WILL NOT RUN IN THIS VERSION OF CSOUNDO
// I'M LEAVING THE CODE HERE IN CASE ANYONE WANTS TO 
// USE IT IN A STANDARD CSOUNDO SKETCH.
//=================================================
import csoundo.*;

Csoundo cs;

color col=color(255,255,192);
color foodColor = color(255,0, 0);
float speed = 100;
int cx, cy;
 
int moveX = 0;
int moveY = 0;
int snakeX = 0;
int snakeY = 0;
int foodX = -1;
int numberOfNotes = 1;
int foodY = -1;
float speedIncr = 1;
boolean check = true;
int []snakesX;
int []snakesY;
int playNote = 0;

int snakeSize = 1;
int windowHeight;
int windowWidth;
float controlHeight;
float controlWidth;

boolean gameOver = false;
PFont Font = createFont("Arial",20, true);
int[] obstaclesX = new int[1000];
int[] obstaclesY = new int[1000];
int numberOfObstacles=0;
//=================================================
//setup
//=================================================
void setup(){
//size(int(windowSize), int(windowSize),P3D);
size(displayWidth, displayHeight);
windowHeight = displayHeight-int((displayHeight*.25));
windowWidth = displayWidth;

background(0);
speed = 100;
speed=speed/frameRate;
snakesX = new int[100];
snakesY = new int[100];

cx = width/2;
cy = height/2;
   
snakeX = cx-5;
snakeY = cy-5;
foodX = -1;
foodY = -1;
gameOver = false;
check = true;
snakeSize =1;


//Android Mode 
cs = new Csoundo(this, super.getApplicationContext());
cs.run();
cs.setChn("note", 6);
}

//=================================================
//draw
//=================================================
void draw()
{
if(speed%10 == 0){
   background(0);
   runGame();
   }
speed+=speedIncr;

fill(255, 0, 0);
controlHeight = displayHeight*.2;
controlWidth = displayWidth*.2;

/*
|             |-------|               |
|             |  up   |               |
|             |       |               |
|      |------|-------|-------|       |
|      |      |       |       |       |
|      | left |  down | right |       |
|      |------|-------|-------|       |
*/

rect(controlWidth*2, windowHeight, controlHeight/2, controlHeight/2, 7);
rect(controlWidth, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);
rect(controlWidth*2, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);
rect(controlWidth*3, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);

textFont(Font);
textAlign (CENTER);
fill(255, 255, 255);
int offset = int(controlWidth/2);

text("Up",     (controlWidth*2),       windowHeight+50,                       controlHeight/2,   40);
text("Left",   controlWidth,           (windowHeight+controlHeight/2)+50,  controlHeight/2,  40);
text("Down",   (controlWidth*2),       (windowHeight+controlHeight/2)+50,  controlHeight/2,  40);
text("Right",  (controlWidth*3),       (windowHeight+controlHeight/2)+50,  controlHeight/2,  40);


String scoreString = "Score:"+snakeSize;
text(scoreString, 10, displayHeight-50, controlHeight/2, 40);
}
//=================================================
//Android onPause() and onResume() methods for Csoundo
//=================================================
@Override
public void onPause() {
    super.onPause();  // Always call the superclass method first
    cs.dispose();
}

@Override
public void onResume() {
    super.onResume();  // Always call the superclass method first
    cs = new Csoundo(this, super.getApplicationContext());
    cs.run();
}
//=================================================
//reset
//=================================================
void reset(){
  snakeX = cx-5;
  snakeY = cy-5;
  gameOver = false;
  check = true;
  snakeSize =1;
  speedIncr=1;
  moveY = 0;
  moveX = 0;
}

//=================================================
//run game
//=================================================
void runGame(){
  if(gameOver==false){
    drawfood();
    drawSnake();
    snakeMove();
    ateFood();
    createObstacles();
    checkHitSelf();
  }else{
      String modelString = "game over\ntap screen to restart";
      textAlign (CENTER);
      textFont(Font);
      text(modelString,windowWidth/2,windowHeight/2,40);
  }
}

//=================================================
//check if snake hits itself
//=================================================
void checkHitSelf(){
   for(int i = 1; i < snakeSize; i++){
       if(snakeX == snakesX[i] && snakeY== snakesY[i]){
          gameOver = true;
      }
   } 
}

//=================================================
//ate food
//=================================================
void ateFood(){
  if(foodX == snakeX && foodY == snakeY){
     check = true;
     snakeSize++;
     //freqIncr=freqIncr+.01;
     for(int i=0;i<10;i++){
     obstaclesY[numberOfObstacles+i] = int(random(windowHeight));
     obstaclesX[numberOfObstacles+i] = int(random(windowWidth));
     }
     numberOfObstacles+=10;
     cs.setChn("numberOfNotes", numberOfNotes);
     numberOfNotes++;
  }
  
}

//=================================================
//draw food
//=================================================
void drawfood(){
fill(foodColor);

while(check){
    int x = (int)random(1,displayWidth/10);
    int y =  (int)random(1,windowHeight/10);
    foodX = 5+x*10;
    foodY = 5+y*10;
     
    for(int i = 0; i < snakeSize; i++){
       if(x == snakesX[i] && y == snakesY[i]){
         check = true;
         i = snakeSize;
       }else{
         check = false;
       }
    }
     
  }
   
  rect(foodX-5, foodY-5, 10, 10);
     
}

//=================================================
//draw snake
//=================================================
void drawSnake(){
  fill(col);
 
  for(int i = 0; i < snakeSize; i++) {
    int X = snakesX[i];
    int Y = snakesY[i];
    rect(X-5,Y-5,10,10);
  }
   
  for(int i = snakeSize; i > 0; i--){
    snakesX[i] = snakesX[i-1];
    snakesY[i] = snakesY[i-1];
  }
}
 
//=================================================
//add obstacles
//=================================================
void createObstacles(){
  for(int i=0;i<numberOfObstacles;i++){
  fill(random(100), random(255), random(255));
  rect(obstaclesX[i], obstaclesY[i], 10, 10);
  }
}

//=================================================
//move snake
//================================================= 
void snakeMove(){
  snakeX += moveX;
  snakeY += moveY;
  if(snakeX > displayWidth-5 || snakeX < 5 || snakeY > (windowHeight)-5 || snakeY < 5){
     gameOver = true;
  }
  
  for(int i=0;i<numberOfObstacles;i++){
   if(snakeY > obstaclesY[i]-8 && snakeY < obstaclesY[i]+8)
   if(snakeX > obstaclesX[i]-8 && snakeX < obstaclesX[i]+8)
   gameOver = true;  
  }

  snakesX[0] = snakeX;
  snakesY[0] = snakeY;
  
 // if(playNote%2==0){
  float rand = random(numberOfNotes);
  cs.setChn("note", int(rand));
  //}
 // playNote++;
 
}
  
//=================================================
//mouse pressed
//=================================================  
void mousePressed() {
//up:    rect(controlWidth*2, windowHeight, controlHeight/2, controlHeight/2, 7);
//left:  rect(controlWidth, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);
//down:  rect(controlWidth*2, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);
//right: rect(controlWidth*3, (windowHeight+controlHeight/2)+10, controlHeight/2, controlHeight/2, 7);  
  
  if(mouseY>windowHeight){
  
  //up  
  if((mouseX>controlWidth*2) && (mouseX<controlWidth*3) && 
     (mouseY>windowHeight) && (mouseY<windowHeight+controlHeight/2))
     {   
        if(snakesY[1] != snakesY[0]-10){
          moveY = -10; 
          moveX = 0;
        }
     }
  //down
  if((mouseX>controlWidth*2) && (mouseX<controlWidth*3) && 
     (mouseY>windowHeight+controlHeight/2))
     {
        if(snakesY[1] != snakesY[0]+10){
          moveY = 10; 
          moveX = 0;
        }
     }
  
  //left
  if((mouseX>controlWidth) && (mouseX<controlWidth*2) && 
     (mouseY>windowHeight+controlHeight/2))
     {
        if(snakesX[1] != snakesX[0]-10){
          moveX = -10; 
          moveY = 0;
        }
     }
     
  //right
  if((mouseX>controlWidth*3) && (mouseX<controlWidth*4) && 
     (mouseY>windowHeight+controlHeight/2))
     {
        if(snakesX[1] != snakesX[0]+10){
          moveX = 10; 
          moveY = 0;
        }
     }
  
}
else
  if(gameOver)
  reset();  
}
