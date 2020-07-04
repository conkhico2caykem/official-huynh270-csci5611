Camera camera;

// 3D dimensions
float height3D = 500;
float width3D = 500;
float depth = -500;

int n = 40;			// number of cells
float dx = width3D/n;	// width of cell
float g = 10.0;			// gravity
float damp = 0.8;		// damping

float h[] = new float[n];		// height
float hu[] = new float[n];		// momentum
float dhdt[] = new float[n];	// height
float dhudt[] = new float[n];	// momentum

// Midpoint helpers
float h_mid[] = new float[n];		// height
float hu_mid[] = new float[n];		// momentum
float dhdt_mid[] = new float[n];	// height
float dhudt_mid[] = new float[n];	// momentum

void initScene(){
	for (int i = 0; i < n; i++){
		h[i] = 50 + 400/(sq(i-5)+10);
		hu[i] = 0;
	}
}

void setup(){
	size(1000, 800, P3D);
	surface.setTitle("Water Simulator");
	
	camera = new Camera();
	camera.position = new PVector(250, 0, 430);
	camera.phi = -0.64;
	initScene();
}

float dhudx;
float dhu2dx;
float dgh2dx;
float dhudx_mid;
float dhu2dx_mid;
float dgh2dx_mid;

void update(float dt){
	// compute midpoint heights and momentums
	for (int i = 0; i < n-1; i++){
		h_mid[i] = (h[i+1]+h[i])/2.0;
		hu_mid[i] = (hu[i+1]+hu[i])/2.0;
	}
	
	for (int i = 0; i < n-1; i++){
		// Compute dh/dt (mid)
		dhudx_mid = (hu[i+1] - hu[i])/dx;
		dhdt_mid[i] = -dhudx_mid;
		
		// Compute dhu/dt (mid)
		dhu2dx_mid = (sq(hu[i+1])/h[i+1] - sq(hu[i])/h[i])/dx;
		dgh2dx_mid = g*(sq(h[i+1]) - sq(h[i]))/dx;
		dhudt_mid[i] = -(dhu2dx_mid + .5*dgh2dx_mid);
	}
	
	// integrate midpoint
	for (int i = 0; i < n-1; i++){
		h_mid[i] += dhdt_mid[i] * dt / 2;
		hu_mid[i] += dhudt_mid[i] * dt / 2;
	}
	
	for (int i = 1; i < n-1; i++){
		// compute dh/dt
		dhudx = (hu_mid[i] - hu_mid[i-1])/dx;
		dhdt[i] = -dhudx;
		
		// compute dhu/dt
		dhu2dx = (sq(hu_mid[i])/h_mid[i] - sq(hu_mid[i-1])/h_mid[i-1])/dx;
		dgh2dx = g*(sq(h_mid[i]) - sq(h_mid[i-1]))/dx;
		dhudt[i] = -(dhu2dx + .5*dgh2dx);
	}
	
	// integrate heights and momentum
	for (int i = 0; i < n-1; i++){
		h[i] += damp * dhdt[i] * dt;
		hu[i] += damp * dhudt[i] * dt;
	}
	
	// reflective boundary condition
	h[0] = h[1];
	h[n-1] = h[n-2];
	hu[0] = -hu[1];
	hu[n-1] = -hu[n-2];
}

void draw(){
	background(255);
	noStroke();
	fill(0,127,255);
	
	ambientLight(128, 128, 128);
	directionalLight(255,255,255, -0.5, 1, -0.25);
	lightFalloff(1, 0.001, 0);
	lightSpecular(64,64,64);
	
	// surface of water
	beginShape(QUAD_STRIP);
	for (int i = 0; i < n; i++){
		float x = i*dx;
		
		vertex(x, height3D-h[i], 0);
		vertex(x, height3D-h[i], depth);
	}
	endShape();
	
	// front
	beginShape(QUAD_STRIP);
	for (int i = 0; i < n; i++){
		float x = i*dx;
		
		vertex(x, height3D-h[i], 0);
		vertex(x, height3D, 0);
	}
	endShape();
	
	update(10.0/frameRate);
	camera.Update(1.0/frameRate);
	println(camera.position, camera.phi);
}


void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
