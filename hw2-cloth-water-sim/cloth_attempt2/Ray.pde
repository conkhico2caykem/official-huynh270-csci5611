// Ray Library [3D]
// Written by Reese Jacobson for CSCI 5611
// Based on https://github.com/ivlab/MinGfx/blob/master/src/ray.cc
// Feel free to modify and reuse however you'd like.

public class Ray {
  public Vec3 p, d;
  
  // Return values for intersection functions
  public Vec3 iPoint;
  public float iTime;
  
  public Ray(Vec3 origin, Vec3 direction){
    p = origin;
    d = direction;
  }
  
  public String toString(){
    return "origin: " + p.toString() + ", direction: " + d.toString();
  }
  
  public float length(){
    return d.length();
  }
  
  public boolean intersectPlane(Vec3 planePt, Vec3 planeNorm){
    float plane_dot_d = dot(planeNorm, d);
    
    // return false if we would hit the back face of the plane
    if (plane_dot_d > 0.0){
      return false;
    }
    
    // return false if the ray and plane are parallel
    if (abs(plane_dot_d) < 1E-8){
      return false;
    }
    
    if (abs(plane_dot_d) > 1E-8){
      iTime = dot(planePt.minus(p), planeNorm) / plane_dot_d;
      if (iTime >= 0){
        iPoint = p.plus(d.times(iTime));
        return true;
      }
    }
    return false;
  }
}
