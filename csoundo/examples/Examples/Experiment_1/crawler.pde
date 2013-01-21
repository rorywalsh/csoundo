class Crawler {
    Net net;
    Edge edge;
    float edge_pos;
    float distance;
    float radius = CRAWLER_RADIUS;
    
    float velocity = random(MIN_CRAWLER_VELOCITY, MAX_CRAWLER_VELOCITY);
    
    Crawler(Net _net) {
        net = _net;
        Node n;
        boolean is_isolated = true;
        
        n = (Node) net.nodes.get(int(random(net.nodes.size())));
        is_isolated = net.is_node_isolated(net.nodes, n);

        while (is_isolated) {
            n = (Node) net.nodes.get(int(random(net.nodes.size())));
            is_isolated = net.is_node_isolated(net.nodes, n);
        }
        
        ArrayList near_nodes = new ArrayList();
        near_nodes = net.get_near_nodes(n);
        
        int r = int(random(near_nodes.size()));
        Node end = (Node) near_nodes.get(r);
        
        Node start = n;
        edge = new Edge(start, end);
        edge_pos = 0.0;
        distance = dist(edge.node_1.xpos, edge.node_1.ypos,
                        edge.node_2.xpos, edge.node_2.ypos);
    }
        
    void bang() {
        if (edge.node_1 != edge.node_2) {
            net.ac.add(new SimpleRipple(this));
        }                        
    }
            
    void display() {
        if (edge.node_1 == edge.node_2) {
            pushStyle();
            float col = random(255);
            fill(255, col, random(col), 180);
            ellipseMode(RADIUS);
            float x = edge.node_1.xpos;
            float y = edge.node_1.ypos;
            float r = edge.node_1.r;
            ellipse(x, y, r, r);            
            popStyle();        
        } else {
            pushStyle();
            strokeWeight(2.0);
            float col = random(255);
            noStroke();
            fill(255, col, random(col), 180);
            ellipseMode(RADIUS);
            
            float x = get_x();
            float y = get_y();
            ellipse(x, y, radius, radius);
            
            float col_2 = random(255.0);
            stroke(255, col_2, random(col_2), 128);
            line(edge.node_1.xpos, edge.node_1.ypos,
                 edge.node_2.xpos, edge.node_2.ypos);
            popStyle();
        }
    }

    float get_x() {
        return lerp(edge.node_1.xpos, edge.node_2.xpos, (edge_pos / distance));
    }    
        
    float get_y() {
        return lerp(edge.node_1.ypos, edge.node_2.ypos, (edge_pos / distance));
    }    
        
    void move() {
        edge_pos += velocity;
    }

    void next_edge() {
        // choose new node
        ArrayList near_nodes = new ArrayList();
        
        float d;        
        int i;

        near_nodes = net.get_near_nodes(edge.node_2);
        Node new_n = node_chooser(edge, near_nodes);

        // Calculate distance and direction
        edge = new Edge(edge.node_2, new_n);
        edge_pos = 0.0;
        distance = dist(edge.node_1.xpos, edge.node_1.ypos,
                        edge.node_2.xpos, edge.node_2.ypos);
    }

    Node node_chooser(Edge e, ArrayList node_list) {
        int size = node_list.size();
        float[] delta = new float[size];
        float total = 0.0;

        // Get direction
        float v = (atan2(edge.node_2.ypos - edge.node_1.ypos,
                   edge.node_2.xpos - edge.node_1.xpos) + PI) % TWO_PI;
        float v2;
        int i;

        if (size == 1) {
            return (Node) node_list.get(0); 
        }
        
        // Create statistics table for adjacent nodes
        for (i = 0; i < node_list.size(); i++) {
            Node n2 = (Node) node_list.get(i); 
            v2 = atan2(n2.ypos - edge.node_2.ypos, n2.xpos - edge.node_2.xpos);
            if (v2 < 0) v2 += TWO_PI;
            float s = abs(v2 - v) % PI;
            total = total + s;
            delta[i] = total;
        }

        float r = random(total);
        
        for (i = 0; i < size; i++) {
            if (r < delta[i]) {
                return (Node) node_list.get(i);
            }
        }
        
        if (net.is_node_isolated(net.nodes, edge.node_2)) {
            return edge.node_2;
        }

        println("Oops. Something ain't right in node_chooser of class Net.");
        return edge.node_2;
    }

    void update() {
        if (edge_pos >= distance - velocity) {
            next_edge();            
            bang();
        } else {
            move();
        }    

        display();
    }
}



