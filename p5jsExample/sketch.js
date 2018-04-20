/** Csound p5.js Example
 *  Based on code posted by Steven Yi <stevenyi@gmail.com> to the Csound mailing list.
 *  Modified by RW, 2018
 *
 *  Description: Simple p5 sketch that draws random circles to the
 *  screen and triggers an corresponing random note. The cs var has been
 *  created globally in the csound-p5js.js file
 */


var textAlpha = 0;
var textAlphaSpeed = 0.01;

function setup()
{
    var cnvs = createCanvas(windowWidth, windowHeight);
    cnvs.style('display', 'block');
    textAlign(CENTER);
    frameRate(3)
}

function draw()
{
    background(0,0,0);

    if(csoundLoaded)
    {
        //put all Csound API calls here
        x = random(width);
        y = random(height);
        amp = random(15000);

        cs.setControlChannel("pitch", y);
        cs.setControlChannel("pan", x/740);
        cs.setControlChannel("amp", amp);


        fill(255, (x/800) * 255, 0, (y/480) * 255);
        ellipse(x,y, 20*(amp/2500), 20*(amp/2500));
        fill(0, 0, 0, 10);
        rect(0, 0, width, height);
    }
    else
    {
        //basic code to indicate Csound is still loading...
        fill(0, 0, 100, textAlpha);
        text("...LOADING CSOUND...", width/2, height/2);
        textAlpha += textAlphaSpeed;
        if(textAlpha > 1 || textAlpha < 0)
        {
          textAlphaSpeed *= -1;
        }
    }
}


function windowResized()
{
    resizeCanvas(windowWidth, windowHeight);
}
