//Vector Library [2D]
//CSCI 5611 Vector 3 Library [Incomplete]

//Instructions: Add 3D versions of all of the 2D vector functions
//              Vec3 must also support the cross product.
public class Vec3 {
  public float x, y, z;
  
  public Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  } // end Vec3 constructor
  
  public String toString(){
    return "(" + x + "," + y + "," + z + ")";
  } // end toString
  
  public float length(){
    return sqrt((x*x)+(y*y)+(z*z));
  }// end length
  
  public Vec3 plus(Vec3 rhs){
    return new Vec3(x+rhs.x, y+rhs.y, z+rhs.z);
  } // end plus
  
  public void add(Vec3 rhs){
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
  } // end add
  
  public Vec3 minus(Vec3 rhs){
    return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
  } // end minus
  
  public void subtract(Vec3 rhs){
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
  } // end subtract
  
  public Vec3 times(float rhs){
    return new Vec3(x*rhs, y*rhs, z*rhs);
  } // end times
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
    z *= rhs;
  } // end mul
  
  public void normalize(){
    float mag = sqrt(x*x + y*y + z*z);
    x /= mag;
    y /= mag;
    z /= mag;
  } // end normalize
  
  public Vec3 normalized(){
    float mag = sqrt(x*x + y*y + z*z);
    return new Vec3(x/mag, y/mag, z/mag);
  } // end normalized
  
  public float distanceTo(Vec3 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    float dz = rhs.z - z;
    return sqrt(dx*dx + dy*dy + dz*dz);
  } // end distanceTo
}

Vec3 interpolate(Vec3 a, Vec3 b, float t){
  return a.plus((b.minus(a)).times(t)); 
} // end interpolate

float dot(Vec3 a, Vec3 b){
  return a.x*b.x + a.y*b.y + a.z*b.z;
} // end dot

Vec3 cross(Vec3 a, Vec3 b){
  float i = a.y*b.z - a.z*b.y;
  float j = a.z*b.x - a.x*b.z;
  float k = a.x*b.y - a.y*b.x;
  return new Vec3(i, j, k);
} // end cross

Vec3 projAB(Vec3 a, Vec3 b){
  return b.times(a.x*b.x + a.y*b.y + a.z*b.z);
}
