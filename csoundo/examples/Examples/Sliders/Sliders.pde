/*
 * A bank of seven sliders controlling an FM synthesizer (foscil). The
 * sliders are generated using the controlP5 library by Andreas Schlegel.
 * Great for old school lasers and UFOs.
 *
 * Downlaod controlP5: http://www.sojamo.de/libraries/controlP5/
 *
 * Example by Jacob Joaquin
 */
 
 import controlP5.*;
import csoundo.*;

ControlP5 controlP5;
Csoundo cs;

void setup() {
    size(550, 220);
    frameRate(30);
    smooth();

    controlP5 = new ControlP5(this);
    //Android Mode (comment out either)
    //cs = new Csoundo(this, super.getApplicationContext());
    //Java Mode
    cs = new Csoundo(this, "Sliders.csd");
    cs.run();

    // Set default values in Csound chn bus memory
    cs.setChn("amp", 0.707);
    cs.setChn("freq", 100);
    cs.setChn("c", 1.0);
    cs.setChn("m", 1.0);
    cs.setChn("index", 1.0);
    cs.setChn("lfo_amp", 0.0);
    cs.setChn("lfo_rate", 0.0);

    // Create sliders
    controlP5.addSlider("amp", 0, 1, 0.707, 40, 40, 40, 120);
    controlP5.addSlider("freq", 100, 200, 100, 110, 40, 40, 120);
    controlP5.addSlider("c", 0, 8, 1.0, 180, 40, 40, 120);
    controlP5.addSlider("m", 0, 8, 1.0, 250, 40, 40, 120);
    controlP5.addSlider("index", 0, 8, 1.0, 320, 40, 40, 120);
    controlP5.addSlider("lfo_amp", 0, 1, 0.0, 390, 40, 40, 120);
    controlP5.addSlider("lfo_rate", 0, 20, 0.0, 470, 40, 40, 120);
}

void draw() {
    background(0);
}

void controlEvent(ControlEvent e) {
    // Update chn bus related to ControlEvent
    cs.setChn(e.controller().name(), e.controller().value());
}
