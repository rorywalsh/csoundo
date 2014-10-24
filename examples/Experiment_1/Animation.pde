class AnimationController {
    ArrayList animations;  // Active animations
    ArrayList garbage;     // Collect animations to be destroyed

    AnimationController() {
        animations = new ArrayList();
        garbage = new ArrayList();
    }

    void add(Animation a) {
        animations.add(a);
    }

    void empty_garbage() {
        int i;
        
        for (i = 0; i < garbage.size(); i++) {
            Animation a = (Animation) garbage.get(i);
            animations.remove(animations.indexOf(a));
        }
        
        garbage.clear();        
    }

    void update() {
        update_animations();
        empty_garbage();    
    }

    void update_animations() {
        int i;
        
        for (i = 0; i < animations.size(); i++) {
            Animation a = (Animation) animations.get(i);
            a.update();
            a.frames_left--;
            
            if (a.frames_left <= 0) {
                garbage.add(a);
            }
        }        
    }
}

class Animation {
    int frames_left = 0;

    Animation() {}
    
    void update() {}
}

class SimpleRipple extends Animation {
    float xpos;
    float ypos;
    float r;
    float start_opacity = 96;
    float opacity = start_opacity;
    float grow = 1.05;
    float total_frames;
    Crawler c;
    Edge e;

    SimpleRipple(Crawler _c) {
        super();
        c = _c;
        e = c.edge;

        this.frames_left = (int) (get_duration() * (float) frameRate);
        total_frames = (float) frames_left;
        xpos = e.node_1.xpos;
        ypos = e.node_1.ypos;
        r = e.node_1.r;
        sound();
    }
    
    void display() {
        pushStyle();
        noStroke();
        ellipseMode(RADIUS);
        fill(255, 200, 0, opacity);
        ellipse(xpos, ypos, r, r);
        fill(0, opacity);
        ellipse(e.node_1.xpos, e.node_1.ypos, e.node_1.r, e.node_1.r);
        popStyle();
    }
    
    float get_duration() {
        return dist(e.node_1.xpos, e.node_1.ypos, e.node_2.xpos, 
                    e.node_2.ypos) / c.velocity / frameRate;    
    }
    
    void update() {
        opacity -= (start_opacity * (1.0 / (float) total_frames));
        
        if (opacity < 0) opacity = 0;
        r = r * grow;
        display();
    }

    void sound() {
        NodeSound ns;
        ns = (NodeSound) net.node_sounds.get(net.nodes.indexOf(e.node_1));
        float amp = AMP;
        float freq = ns.freq;
        float pan = e.node_1.xpos / (float) width;
        float index = (float) net.nodes.indexOf(e.node_1) / (float) N_NODES;
    
        cs.event("i 1 0 " + get_duration() + " " + amp + " " + freq +
                       " " + pan + " " + index);
    }
    
    void sound(float dur, float amp, float freq, float pan, float index) {        
        cs.event("i 1 0 " + dur + " " + amp + " " + freq + " " + pan +
                       " " + index);
    }
    
}


