class Edge {
    Node node_1;
    Node node_2;

    Edge(Node n_1, Node n_2) {
        node_1 = n_1;
        node_2 = n_2;
    }
    
    void display() {
        pushStyle();
        float col = random(255.0);
        stroke(255, col, random(col), 96);
        strokeWeight(1);
        line(node_1.xpos, node_1.ypos, node_2.xpos, node_2.ypos);
        popStyle();
    }
    
    void update() {
        display();
    }
}

