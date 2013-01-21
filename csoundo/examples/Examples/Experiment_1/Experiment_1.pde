/*
 * Something between a lava lamp and a wind chime.
 * 
 * Example by Jacob Joaquin
 */
 
 import csoundo.*;

Net net;
Csoundo cs;

float SCALE = 1;
int N_NODES = 50;
float MIN_NODE_SIZE = 5.0 * SCALE;
float MAX_NODE_SIZE = 100.0 * SCALE;
float MAX_NODE_VELOCITY = 1 * SCALE;
float MIN_NODE_VELOCITY = 0.3 * SCALE;
int N_CRAWLERS = 2;
float CRAWLER_RADIUS = 5 * SCALE;
float MAX_CRAWLER_VELOCITY = 2 * SCALE;
float MIN_CRAWLER_VELOCITY = 0.5 * SCALE;
float AMP = 0.6;
float BASE_FREQ = 180;
boolean IS_SOUND_ON = true;
boolean setup = false;

void setup() {
    size((int) (720 * SCALE), (int) (480 * SCALE));
    frameRate(30);
    smooth();

    net = new Net(N_NODES, MIN_NODE_SIZE, MAX_NODE_SIZE);

    if (IS_SOUND_ON) {
        //Android Mode (comment out either)
        cs = new Csoundo(this, super.getApplicationContext());
        //Java Mode(ensure to comment out onPause/onResume methods below also)
        //cs = new Csoundo(this, "Experiment_1.csd");
        cs.run();
        setup = true;
        
    }
}

void draw() {
    if (mousePressed) {
        net = new Net(N_NODES, MIN_NODE_SIZE, MAX_NODE_SIZE);
    }
    
    background(32, 0, 0);
    net.update();
}

//Comment out method onPause for Java mode
@Override
public void onPause() {
    super.onPause();  // Always call the superclass method first
    if(setup){
      cs.pause();
    }
}
//Comment out method onResume for Java mode
@Override
public void onResume() {
    super.onResume();  // Always call the superclass method first
    if(setup){
      cs.resume();
    }
}

void keyPressed() {
   // net = new Net(N_NODES, MIN_NODE_SIZE, MAX_NODE_SIZE);
}

float random_range_scaled(float min, float max) {
    return min * pow((max / min), random(1.0));
}

class NodeSound {
    float freq;
    float timbre;
}

