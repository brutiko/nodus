
PFont font;

int h = 800;
int w = 600;

PImage img;
PFont WQY10;

int numBalls = 25600;
int maxBalls = numBalls;
int fps;
boolean clearBG, doSmooth;
int shapeType;
float maxVelocity = 16, minAccel = 0.8, maxAccel = 1.8;

float larg;
float positx;
float posity;
Seeker[] ball = new Seeker[numBalls];

int numPoints = 28;
PVector[] points = new PVector[numPoints];


int radius = 15;

int particleCount = 2000;

Particle[] particles = new Particle[particleCount+1];


// Setup the Processing Canvas
void setup(){

  int x,y;
  size(800,600);

  img = createImage(800, 600, ARGB);
      for(int i=0; i < img.pixels.length; i++) {
      x = i%800;
      y = i/800;
      img.pixels[i] = color(217, 215, 210+x/10.0);
      }

   colorMode(HSB, 360, 100, 100);
   noStroke();

   WQY10 = loadFont("AndaleMono.vlw");
   textFont(WQY10);

   clearBG = true;
   doSmooth = false;
   shapeType = 0;
   frameRate(30);

   for(int i=0; i<numBalls; i++){
       ball[i] = new Seeker(new PVector(random(width), random(height)));
   }

   // numBalls adjusted to a sane default for web distribution
   numBalls = 700;


   fill(#ffffff);

   stroke(#ffffff);

    for (int g = particleCount; g >= 0; g--) {
      particles[g] = new Particle();
    };

}

// Main draw loop
void draw(){

    smooth();
    background(0);
    noFill();

    rectMode(CENTER);

    for(int i=0; i<numBalls; i++){
        ball[i].seek(new PVector(mouseX, mouseY));
        ball[i].render();
    }
}

class Particle {
  float x;
  float y;
  float vx;
  float vy;


  Particle() {
    x = random(10,width-10);
    y = random(10,height-10);
  }

  void update() {

    //PVector currentMovement = motionDetector.getMovement(1);


      float rx = mouseX;
      float ry = mouseY;

      float radius = dist(x,y,rx,ry);

      if (radius < 150) {

        float angle = atan2(y-ry,x-rx);

        vx -= (150 - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (150 - radius)));
        vy -= (150 - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (150 - radius)));
      }


    x += vx;
    y += vy;


    vx *= 0.97;
    vy *= 0.97;


    if (x > width-10) {
      vx *= -1;
      x = width-11;
    }
    if (x < 10) {
      vx *= -1;
      x = 11;
    }
    if (y > height-10) {
      vy *= -1;
      y = height-11;
    }
    if (y < 10) {
      vy *= -1;
      y = 11;
    }
     stroke(random(115, 285), 85, 85);
     point((int)x,(int)y);

  }
}

class Seeker{
  PVector position;
  float accelRate, radius;
  PVector velocity = new PVector(0, 0);
  color fillColor;

  public Seeker(PVector pos){
    position = pos;
    colorMode(HSB, 360, 100, 100);

    fillColor = color(random(115, 285), 85, 85, 70);
  }

  public void seek(PVector target){
    float rnd;
    rnd = random(2);
    accelRate = map(rnd, 0, 1, minAccel, maxAccel);
    target.sub(position);
    target.normalize();
    target.mult(accelRate);
    velocity.add(target);
    velocity.limit(maxVelocity);

    position.add(velocity);
  }

  public void render(){
    fill(fillColor);
    radius = sq(map(velocity.mag(), 0, maxVelocity, 4, 1));
    if(shapeType == 0){
      noStroke();
      rect(position.x, position.y, radius, radius);
    }
    else{
      ellipse(position.x, position.y, radius, radius);
    }
  }
}

