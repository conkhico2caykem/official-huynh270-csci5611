int numP = 10000000;
int particleInc = 50;
PFont font;
PShape whale;

public ArrayList<Vec3> pos;
public ArrayList<Vec3> vel;
public ArrayList<Vec3> acc;

int offset = 50;

void setup() {
  size(800, 800, P3D); // window size
  surface.setTitle("CSCI 5611 - HW 01 - Particle System");
  whale = loadShape("whale.svg");
  //bg = loadImage("cartoonaqua1080.jpg");
  font = createFont("Arial", 16, true);
  
  // Initialize particles
  pos = new ArrayList<Vec3>();
  vel = new ArrayList<Vec3>();
  acc = new ArrayList<Vec3>();
  
  for( int i = 0; i < particleInc; i++) {
        Vec3 newPos = new Vec3(400, 400, 0);
        Vec3 newVel = new Vec3(0, 0, 0);
        Vec3 newAcc = new Vec3(0, 0.1, 0);
        if (i > 0) {
            newVel = new Vec3(random(-2,2), random(-5,-10), random(-2, 2));
        } else {
            newVel = new Vec3(0, 0, 0);
        }
        pos.add(newPos);
        vel.add(newVel);
        acc.add(newAcc);
    }
}


void update () {
  for (int i = 0; i < pos.size(); i++) {
    if (pos.get(i).x > width || pos.get(i).y > height) {
      // remove off screen particle
      pos.remove(i);
      vel.remove(i);
      acc.remove(i);
    }
  }
  // add increments of 50 particles until numP is reached
  for (int i = 0; i < particleInc; i++) {
    // add new particle
    Vec3 newPos = new Vec3(400, 400, 0);
    Vec3 newVel = new Vec3(0, 0, 0);
    Vec3 newAcc = new Vec3(0, 0.1, 0);
    newVel = new Vec3(random(-1,1), random(-5,-15), random(-1, 1));
    pos.add(newPos);
    vel.add(newVel);
    acc.add(newAcc);
      
    if(pos.size() >= numP)
    {
      break;
    }
  }
    
  
  
  for( int i = 0; i < pos.size(); i++) {
    if (i > 0) {
      vel.get(i).add( acc.get(i));
    }
    pos.get(i).add( vel.get(i));
  }
}


void draw() {
    update();
    background(0);
    shape(whale, 0, 0);
    stroke(255);
    strokeWeight(1);
    
    for( int i = 0; i < pos.size(); i++) {
        pushMatrix();
        //translate(pos.get(i).x, pos.get(i).y, pos.get(i).z);
        point(pos.get(i).x, pos.get(i).y, pos.get(i).z);
        popMatrix();
        //point( pos.get(i).x + width/2, pos.get(i).y + height );
    }
}
