// CSCI 5611 Project 2
// Crystal Huynh, Reese Jacobson

Camera camera;

int nx = 11;
int ny = 11;
float floor = 500;
float gravity = 400;
float radius = 1.0;
float originX = 100;
float originY = 100;
float restLen = 10;
float mass = 0.3;
float ks_v = 800;
float kd_v = 70;
float ks_h = 50;
float kd_h = 5;
float drag = 0;

float objR = 20.0;
float objClickThresh = 50;

// Position of the interaction shape
Vec3 objP = new Vec3(objR, objR, -30);


//Inital positions and velocities of masses [col][row]
static int maxNodes = 100;
Vec3 nodes[][] = new Vec3[maxNodes][maxNodes];
Vec3 vel[][] = new Vec3[maxNodes][maxNodes];
Vec3 acc[][] = new Vec3[maxNodes][maxNodes];


void initScene(){
  for (int i = 0; i < nx; i++){
    for (int j = 0; j < ny; j++) {
      nodes[i][j] = new Vec3(originX + (restLen * i), originY, (restLen * j));
      vel[i][j] = new Vec3(0, 0, 0);
      acc[i][j] = new Vec3(0, 0, 0);
    }
  }
}

void setup() {
  size(500, 500, P3D);
  surface.setTitle("Cloth Simulation");
  camera = new Camera();
  camera.position = new PVector(-70, 190, 430);
  camera.theta = -0.46;
  initScene();
}

void update(float dt) {
  Vec3 newAcc[][] = new Vec3[maxNodes][maxNodes];
  newAcc = acc;
  // update vertical
  for (int i = 0; i < nx; i++) {
    for (int j = 0; j < ny - 1; j++) {
      // find force vector generated by spring
      Vec3 deltaSpringV = nodes[i][j+1].minus(nodes[i][j]);
      float deltaLen = deltaSpringV.length();
      float springForce = -ks_v * (deltaLen - restLen);
      
      Vec3 compVec = deltaSpringV.normalized();
      
      // find dampening force
      float dampBot = dot(vel[i][j], compVec);
      float dampTop = dot(vel[i][j+1], compVec);
      float dampForce = -kd_v * (dampTop - dampBot);
      
      // resolve forces
      Vec3 force = compVec.times(springForce + dampForce);
      
      Vec3 deltaAcc = force.times(0.5 / mass);
      Vec3 dragForce = deltaAcc.times(drag);
      newAcc[i][j].subtract(deltaAcc.plus(dragForce));
      newAcc[i][j+1] = (deltaAcc.minus(dragForce));
    }
  }
  
  // update horizontal
  for (int i = 0; i < nx - 1; i++) {
    for (int j = 0; j < ny; j++) {
      // find force vector generated by spring
      Vec3 deltaSpringV = nodes[i+1][j].minus(nodes[i][j]);
      float deltaLen = deltaSpringV.length();
      float springForce = -ks_h * (deltaLen - restLen);
      
      Vec3 compVec = deltaSpringV.normalized();
      
      // find dampening florce
      float dampBot = dot(vel[i][j], compVec);
      float dampTop = dot(vel[i+1][j], compVec);
      float dampForce = -kd_h * (dampTop - dampBot);
      
      // resolve forces
      Vec3 force = compVec.times(springForce + dampForce);
      
      Vec3 deltaAcc = force.times(0.5 / mass);
      newAcc[i][j].subtract(deltaAcc);
      newAcc[i+1][j].add(deltaAcc);
    }
  }

  acc = newAcc;

  //Eulerian integration
  for (int i = 0; i < nx; i++) {
    for (int j = 1; j < ny; j++) {
      acc[i][j].y += gravity;
      vel[i][j] = vel[i][j].plus(acc[i][j].times(dt));
      nodes[i][j] = nodes[i][j].plus(vel[i][j].times(dt));
    }
  }
  
  // Object (sphere) collision
  for (int i = 0; i < nx-1; i++) {
    for (int j = 1; j < ny-1; j++) {
      Vec3 avgPos = nodes[i][j].plus(nodes[i+1][j]).plus(nodes[i][j+1]).plus(nodes[i+1][j+1]).times(0.25);
      Vec3 avgVel = vel[i][j];
      
      float dist = avgPos.distanceTo(objP);
      if (dist < radius + objR) {
        Vec3 normal = avgPos.minus(objP);
        normal.normalize();
        Vec3 bounce = normal.times(dot(avgVel, normal));
        vel[i][j].subtract(bounce.times(0.9));
        vel[i+1][j].subtract(bounce.times(0.9));
        vel[i][j+1].subtract(bounce.times(0.9));
        vel[i+1][j+1].subtract(bounce.times(0.9));
        nodes[i][j].add(normal.times(objR - dist + radius));
        nodes[i+1][j].add(normal.times(objR - dist + radius));
        nodes[i][j+1].add(normal.times(objR - dist + radius));
        nodes[i+1][j+1].add(normal.times(objR - dist + radius));
      }
    }
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  // draw cloth
  background(255);
	noStroke();
	
	ambientLight(128, 128, 128);
	directionalLight(255,255,255, -0.25, 1, -0.5);
	lightFalloff(1, 0.001, 0);
	lightSpecular(64,64,64);
  
  
  for (int i = 0; i < nx-1; i++){ // horizonal nodes
    for (int j = 0; j < ny-1; j++){ // vertical nodes
      if ((i+j) % 2 == 0){
        fill(255,0,0);
      } else {
        fill(0,0,0);
      }
      beginShape(QUADS);
      vertex(nodes[i][j].x, nodes[i][j].y, nodes[i][j].z);
      vertex(nodes[i+1][j].x, nodes[i+1][j].y, nodes[i+1][j].z);
      vertex(nodes[i+1][j+1].x, nodes[i+1][j+1].y, nodes[i+1][j+1].z);
      vertex(nodes[i][j+1].x, nodes[i][j+1].y, nodes[i][j+1].z);
      endShape();
    }
  }
  
  // draw sphere
  fill(0, 150, 255);
  noStroke();
  pushMatrix();
  translate(objP.x, objP.y, objP.z);
  sphere(objR);
  popMatrix();
  
  
  camera.Update(1.0/frameRate);
  // println(camera.position, camera.theta);
  
  for (int i = 0; i < 20; i++) {
    //update(1.0 / (50.0 * frameRate));
    update(0.001);
  }
}


// function for mouse press
void mouseDragged(){
  //this finds the position of the mouse in model space
  Vec3 mousePos = new Vec3(0,0,0); //mouse coordinates in model space (x,y,z)
  mousePos.x = modelX(mouseX, mouseY, camera.nearPlane);
  mousePos.y = modelY(mouseX, mouseY, camera.nearPlane);
  mousePos.z = modelZ(mouseX, mouseY, camera.nearPlane);
 
  Vec3 camPos = new Vec3(camera.position.x, camera.position.y, camera.position.z);
  Vec3 camForward = new Vec3(camera.forwardDir.x, camera.forwardDir.y, camera.forwardDir.z);
  
  //vector from camera position to mouse position in model space
  Vec3 camToMouse = mousePos.minus(camPos);
  Ray pick_ray = new Ray(camPos, camToMouse);
  
  pick_ray.intersectPlane(objP, camForward.times(-1.0));
  objP = pick_ray.iPoint;
}

void mousePressed(){ mouseDragged(); }

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  Vec3 camForward = new Vec3(camera.forwardDir.x, camera.forwardDir.y, camera.forwardDir.z);
  objP.add(camForward.times(e));
}


void keyPressed() {
  camera.HandleKeyPressed();
}

void keyReleased() {
  camera.HandleKeyReleased();
}