// Class to setup a single boid
class boid 
{
  // attributes
  public Vec2 pos;
  public Vec2 vel;
  public Vec2 acc;
  ArrayList<boid> neighbors;
  
  public int type;
  public int neighborDist = 100;
  private int collisionR = 15;
  private float targetSpeed = 100;
  private float maxForce = 10.0;

  private float rConst = 1.0;      // restitution constant 
  private float sepDist = 30.0;
  private float sepScale = 300.0;
  private float attractDist = 80.0;
  private float alignDist = 60.0;
  private float alignScale = 600.0;
  private float cohesionScale = 5000.0;
 
  // constructor
  boid (Vec2 x0, Vec2 v0, int type) 
  {
    pos = x0;
    vel = v0;
    this.type = type;
    neighbors = new ArrayList<boid>();
  }
  
  // update - called for each boid every timestep 
  void update(float dt)
  {
    // calculate and implment flocking
    flockBehavior();

    // update position and velocity
    pos.add(vel.times(dt));
    vel.add(acc.times(dt));

    // create boundaries for boids to rebound
    if (pos.y > height - collisionR)
    {
      pos.y = collisionR;
      //vel.y *= -rConst;
    }
    if (pos.y < collisionR)
    {
      pos.y = height - collisionR;
      //vel.y *= -rConst;
    }
    if (pos.x > width - collisionR)
    {
      pos.x = collisionR;
      //vel.x *= -rConst;
    }
    if (pos.x < collisionR)
    {
      pos.x = width - collisionR;
      //vel.x *= -rConst;
    }
  } // end update
  
  // member functions
  // flocking behavior
  void flockBehavior()
  {
    Vec2 alignForce = new Vec2(0,0);
    Vec2 sepForce = new Vec2(0,0);
    Vec2 cohesionForce = new Vec2(0,0);
    
    acc = new Vec2(0,0);
    
    // iterate through neighbors to calculate various forces
    for (int i = 0; i < neighbors.size(); i++)
    {
      float dist = pos.distanceTo(neighbors.get(i).pos);
      
      // *** SEPERATION FORCE ***
      // calculate and apply seperation force to the boid
      if ((dist > 0) && (dist < sepDist))
      {
        sepForce = pos.minus(neighbors.get(i).pos).normalized();
        sepForce.setToLength(sepScale/dist);
        acc = acc.plus(sepForce);
      } 

      // *** COHESION FORCE ***
      if (dist < attractDist && dist > 0)
      {
        cohesionForce.add(neighbors.get(i).pos);
      }

      // *** ALIGNMENT FORCE **
      if (dist < alignDist && dist > 0)
      {
        alignForce.add(neighbors.get(i).vel);
      }  
    } // end boid iteration

    // *** COHESION FORCE cont'd ***
    cohesionForce.mul(1.0/neighbors.size());
    if (neighbors.size() > 0)
    {
      cohesionForce = cohesionForce.minus(pos);
      cohesionForce.normalize();
      cohesionForce.times(cohesionScale);
      cohesionForce.clampToLength(maxForce);
      acc = acc.plus(cohesionForce);
    }

    // *** ALIGNMENT FORCE cont'd ***
    alignForce.mul(1.0/neighbors.size());
    if (neighbors.size() > 0)
    {
      alignForce = alignForce.minus(vel);
      alignForce.normalize();
      acc = acc.plus(alignForce.times(alignScale));
    }
    
    //Goal Speed
    Vec2 targetVel = vel;
    targetVel.setToLength(targetSpeed);
    Vec2 goalSpeedForce = targetVel.minus(vel);
    goalSpeedForce.times(1);
    goalSpeedForce.clampToLength(maxForce);
    acc = acc.plus(goalSpeedForce);
    
  } // end flocking behavior
  
   
  void draw()
  {
    stroke(0);
    switch(type) {
      case 0:
      fill(0, 255, 0);
      break;
      
      case 1:
      fill(0, 255, 255);
      break;
      
      case 2:
      fill(255, 0, 0);
      break;
      
      case 3:
      fill(0, 0, 255);
      break;
      
      case 4:
      fill(255, 255, 0);
      break;
      
      default:
        fill(255, 0, 255);
    }
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.calcHeading());
    beginShape();
    vertex(-10, 6);
    vertex(-6, 2);
    vertex(-4, 4);
    vertex(4, 4);
    vertex(8, 0);
    vertex(4, -4);
    vertex(-4, -4);
    vertex(-6, -2);
    vertex(-10, -6);
    endShape(CLOSE);
    popMatrix();
  }
} // end class boid
