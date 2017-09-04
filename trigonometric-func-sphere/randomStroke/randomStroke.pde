// see: http://p5aholic.hatenablog.com/entry/2015/06/15/194250

float velocity = 0;        // tに足す値
float acceleration = 0.05; // velocityに足す値

void setup(){
  size(960, 540, P3D);
}

void draw(){
  background(0, 15, 30);
  
  translate(width/2, height/2, 0);
  rotateX(frameCount*0.01);
  rotateY(frameCount*0.01);
  
  float lastX = 0, lastY = 0, lastZ = 0;
  float radius = 200;
  float s = 0, t = 0;
  
  while(s <= 180){
    float radianS = radians(s);
    float radianT = radians(t);
    float x = radius * sin(radianS) * cos(radianT);
    float y = radius * sin(radianS) * sin(radianT);
    float z = radius * cos(radianS);
    
    stroke(0, 128, 128);
    if(lastX != 0){
      strokeWeight(1);
      line(x, y, z, lastX, lastY, lastZ);
    }
    strokeWeight(15);
    point(x, y, z);
    
    lastX = x;
    lastY = y;
    lastZ = z;
    
    s++;
    t += velocity;
  }
  velocity += acceleration;
}
