class Node {
    float xpos;
    float ypos;
    float r;
    
    float velocity = random(MAX_NODE_VELOCITY - MIN_NODE_VELOCITY) +
                            MIN_NODE_VELOCITY;
    float direction = random(TWO_PI);

    Node(float x, float y, float _r) {
        xpos = x;
        ypos = y;
        r = _r;
    }
    
    void display() {
        float c = net.nodes.indexOf(this);
        
        pushStyle();        
        fill(255, 0, 0, 32);
        noStroke();
        ellipseMode(RADIUS);
        ellipse(xpos, ypos, r, r);
        fill(255, 255 * (c / (float) N_NODES), 0, 128);
        ellipse(xpos, ypos, 2, 2);        
        popStyle();
    }
        
    void move() {
        xpos = xpos + cos(direction) * velocity;
        ypos = ypos + sin(direction) * velocity;
        
        if (xpos < r) {
            xpos = r;
            direction = PI - direction;
        } else if (xpos > width - 1 - r) {
            xpos = width - 1 - r;
            direction = PI - direction;
        }

        if (ypos < r) {
            ypos = r;
            direction = TWO_PI - direction;
        } else if (ypos > height - 1 - r) {
            ypos = height - 1 - r;
            direction = TWO_PI - direction;
        }
    }    

    void update() {
        move();
        display();
    }
}




