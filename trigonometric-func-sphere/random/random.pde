// see: http://p5aholic.hatenablog.com/entry/2015/06/15/194250

int numPoints = 300;
float[] xPos = new float[numPoints];
float[] yPos = new float[numPoints];
float[] zPos = new float[numPoints];

void setup(){
  size(960, 540, P3D);
  
  // 半径200の球体上に点をランダムに配置
  for(int i = 0; i < numPoints; i++){
    float radianS = radians(random(180));
    float radianT = radians(random(360));
    xPos[i] = 200 * sin(radianS) * cos(radianT);
    yPos[i] = 200 * sin(radianS) * sin(radianT);
    zPos[i] = 200 * cos(radianS);
    /*
    x = sin(radianS) * cos(radianT)
    y = sin(radianS) * sin(radianT)
    z = cos(radianS)
    は、半径1の球体の座標を計算していることになる
    */
  }
}

void draw(){
  background(0, 15, 30);
  
  translate(width/2, height/2, 0);
  rotateX(frameCount*0.005);
  rotateZ(frameCount*0.005);
  
  for(int i = 0; i < numPoints; i++){
    stroke(0, 128, 128);
    strokeWeight(8);
    point(xPos[i], yPos[i], zPos[i]);
  }
}
