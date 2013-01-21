class Net {
    ArrayList nodes;
    ArrayList edges;
    ArrayList crawlers;
    AnimationController ac;
    ArrayList node_sounds;
    
    int n_crawlers = N_CRAWLERS;            

    Net(int n_nodes, float min, float max) {
        createNodes(n_nodes, min, max);
        createEdges();
        createCrawlers();
        
        ac = new AnimationController();
        createNodeSounds();
    }

    void createCrawlers() {
        crawlers = new ArrayList();
        int i;
        
        for (i = 0; i < n_crawlers; i++) {
            Crawler crawler = new Crawler(this);
            crawlers.add(crawler);
        }    
    }
    
    void createEdges() {
        edges = new ArrayList();
        int i;
        int j;
        float d;
        
        for (i = 0; i < nodes.size(); i++) {
            Node n1 = (Node) nodes.get(i);
            
            for (j = i + 1; j < nodes.size(); j++) {
                Node n2 = (Node) nodes.get(j);
                d = dist(n1.xpos, n1.ypos, n2.xpos, n2.ypos);
                            
                if (d <= (n1.r + n2.r)) {
                    edges.add(new Edge(n1, n2));
                }
            }
        }
    }
    
    void createNodes(int n, float min, float max) {
        nodes = new ArrayList();
        ArrayList temp_nodes = new ArrayList();
        
        int i;
            
        for (i = 0; i < n; i++) {
            nodes.add(new Node(random(width), random(height), 
                               random_range_scaled(min, max)));
        }
    }

    void createNodeSounds() {
        node_sounds = new ArrayList();
        
//        float[] scale = {0, 3, 5, 7, 9, 11, 12};
        float[] scale = {0, 3, 5, 7, 10, 12, 15, 17, 19, 22,
                         24, 27, 29, 31, 34, 36};
        
        int i;
        
        for (i = 0; i < nodes.size(); i++) {
            Node n = (Node) nodes.get(i);
            NodeSound ns = new NodeSound();
            
            float normal = (1.0 - (n.r - MIN_NODE_SIZE) /
                           (MAX_NODE_SIZE - MIN_NODE_SIZE));
            float foo = scale[(int) (normal * (float) scale.length)];
            ns.freq = BASE_FREQ * pow(2, foo / 12.0);
            ns.timbre = i;
            
            node_sounds.add(ns);
        }
    }
    
    void draw_edges() {
        int i;
        
        for (i = 0; i < edges.size(); i++) {
            Edge edge = (Edge) edges.get(i);
            edge.update();
        }
    }

    void draw_nodes() {
        int i;
        
        for (i = 0; i < nodes.size(); i++) {
            Node n = (Node) nodes.get(i);
            n.update();
        }
    }

    ArrayList get_near_nodes(Node n1) {
        ArrayList near_nodes = new ArrayList();
        int i;
        float d;
        
        for (i = 0; i < this.nodes.size(); i++) {
            Node n2 = (Node) this.nodes.get(i);
            
            if (n1 != n2) {
                d = dist(n1.xpos, n1.ypos, n2.xpos, n2.ypos);
                            
                if (d <= (n1.r + n2.r)) {
                    near_nodes.add(n2);
                }
            }
        }
        
        return near_nodes;
    }
    
    boolean is_node_isolated(ArrayList _nodes, Node n) {
        int i;

        for (i = 0; i < _nodes.size(); i++) {
            Node temp = (Node) _nodes.get(i);
            
            if (temp != n) {
                float d;
                d = dist(temp.xpos, temp.ypos, n.xpos, n.ypos);
                            
                if (d <= (temp.r + n.r)) {
                    return false;
                }
                
            }
        }
        
        return true;
    }
        
    void update() {
        ac.update();
        draw_nodes();
        createEdges();
        draw_edges();
        update_crawlers();
    }
    
    void update_crawlers() {
        int i;
        
        for (i = 0; i < crawlers.size(); i++) {
            Crawler crawler = (Crawler) crawlers.get(i);
            crawler.update();            
        }
    }
}

