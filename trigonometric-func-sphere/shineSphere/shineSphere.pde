// see: http://p5aholic.hatenablog.com/entry/2015/12/10/000000

PImage img; // 光る球体の画像

float velocity = 0;
float acceleration = 0.05;

void setup() {
  fullScreen(P3D);
  // zテストを無効化 - 画像を透過させて奥の図形も描くため
  hint(DISABLE_DEPTH_TEST);
  // 加算合成
  blendMode(ADD);
  imageMode(CENTER);
  // 画像の生成
  img = createLight(random(0.5, 0.8), random(0.5, 0.8), random(0.5, 0.8));
}

// 光る球体の画像を生成する関数
PImage createLight(float rPower, float gPower, float bPower) {
  int side = 200; // 1辺の大きさ
  float center = side / 2.0; // 中心座標

  // 画像を生成
  PImage img = createImage(side, side, RGB);

  // 画像の一つ一つのピクセルの色を設定する
  for (int y = 0; y < side; y++) {
    for (int x = 0; x < side; x++) {
      float distance = (sq(center - x) + sq(center - y)) / 50.0;
      int r = int( (255 * rPower) / distance );
      int g = int( (255 * gPower) / distance );
      int b = int( (255 * bPower) / distance );
      img.pixels[x + y * side] = color(r, g, b);
    }
  }
  return img;
}

void draw() {
  background(0, 15, 30);
  //fill(255);
  //text(frameRate, 50, 50);
  translate(width/2, height/2, 0);
  rotateX(frameCount*0.01);
  rotateY(frameCount*0.01);

  float lastX = 0, lastY = 0, lastZ = 0;
  float radius = 280;
  float s = 0, t = 0;

  while (s <= 180) {
    float radianS = radians(s);
    float radianT = radians(t);
    float x = radius * sin(radianS) * cos(radianT);
    float y = radius * sin(radianS) * sin(radianT);
    float z = radius * cos(radianS);

    stroke(128);
    if (lastX != 0) {
      strokeWeight(1);
      line(x, y, z, lastX, lastY, lastZ);
    }

    pushMatrix();
    // 画像の座標へ原点を移動
    translate(x, y, z);
    // 画像の向きを元に戻す, 3D空間で描画するために必要
    rotateY(-frameCount*0.01);
    rotateX(-frameCount*0.01);
    // 画像を描画
    image(img, 0, 0);
    popMatrix();

    lastX = x;
    lastY = y;
    lastZ = z;

    s++;
    t += velocity;
  }
  velocity += acceleration;
}

void mousePressed() {
  img = createLight(random(0.5, 0.8), random(0.5, 0.8), random(0.5, 0.8));
}
