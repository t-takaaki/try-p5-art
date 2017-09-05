PImage img; // 光る球体の画像

void setup() {
  size(500, 500, P2D);
  imageMode(CENTER);
  // 加算合成
  blendMode(ADD);
  noCursor();
  
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
      // 現在の座標と中心座標の距離(distance)を計算し、distanceで色成分を割ると、中心から遠くなるほど暗い色になるため発光表現になる
      // 中心座標と色設定座標の距離を正確に計るには距離の差の二乗のルートを計算
      //float distance = sqrt(sq(center - x) + sq(center - y));
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
  
  // 画像を描画
  image(img, mouseX, mouseY);
}

void mousePressed() {
  img = createLight(random(0.5, 0.8), random(0.5, 0.8), random(0.5, 0.8));
}

