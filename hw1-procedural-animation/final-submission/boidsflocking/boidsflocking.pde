// boids flocking
// CSCI 5611 HW 1
// Crystal Huynh <huynh270@umn.edu>

PImage bg;
PFont font;

static int numBoids = 300;
ArrayList<boid> boids;

float maxSpeed = 50;

int winH = 1147;
int winL = 934;
int offset = 50;

void setup()
{
  size(1147, 934, P3D); // window size
  surface.setTitle("CSCI 5611 - HW 01 - Boids and Flocking");
  bg = loadImage("cartoonaqua1080.jpg");
  font = createFont("Arial", 16, true);
  
  // Initialize boids
  boids = new ArrayList<boid>();
  Vec2 randX0, randV0;
  for (int i = 0; i < numBoids; i++)
  {
    randX0 = new Vec2(offset + random(winH - (2* offset)),offset + random(winH - (2* offset)));
    randV0 = new Vec2(-1+random(2),-1+random(2));
    randV0.normalize();
    randV0.mul(maxSpeed);
    boids.add(new boid(randX0, randV0, (int)random(5))); 
  }
}

void update(float dt)
{
  getNeighbors();
}

void getNeighbors()
{
  boid currBoid, testBoid;
  float dist;

  // iterate through boids
  for (int i = 0; i < numBoids; i++)
  {
    // current boid
    currBoid = boids.get(i);
    currBoid.neighbors.clear();
    // iterate through boids again
    for (int j = 0; j < numBoids; j++)
    {
      // if current boid and boid to be compared are not the same
      if (i != j)
      {
        testBoid = boids.get(j);
        dist = currBoid.pos.distanceTo(testBoid.pos);
        if (dist <= currBoid.neighborDist && currBoid.type == testBoid.type)
        {
          currBoid.neighbors.add(testBoid);
        }
      }
    }
  }
}

void mouseClicked() {
  Vec2 mousePos = new Vec2(pmouseX, pmouseY);
  for (int i = 0; i < numBoids; i++) {
    boid currBoid = boids.get(i);
    if (currBoid.pos.distanceTo(mousePos) < 30){
      Vec2 newVel = mousePos.minus(currBoid.pos);
      currBoid.vel.x = -newVel.x;
      currBoid.vel.y = -newVel.y;
    }
  }
  
}

void draw()
{
  float dt = 1.0/frameRate;
  update(1.0/frameRate);
  background(bg); // Pretty background
  textFont(font, 12);
  fill(0);
  text(frameRate, 10, 10);
  stroke(0,0,0); 
  fill(10,120,10);
  for (int i = 0; i < numBoids; i++)
  {
    boids.get(i).update(dt);
    boids.get(i).draw();
  }
}
