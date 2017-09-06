// see: http://qiita.com/v_ohji/items/c185fc5b29b4d2b7425c

int line_num;
int box_num;

float px, py, pz;
float dx, dy, dz;

float ampx, ampy, ampz;

float pn_time;

float offsetx;
float offsety;
float offsetz;

float tlx, tly, tlz;
float stx, sty, stz;
float enx, eny, enz;
float dtx, dty, dtz;

ArrayList<LineObject> lines = new ArrayList<LineObject> ();
ArrayList<BoxObject> boxes = new ArrayList<BoxObject> ();

void setup () {
  // size (1920, 1080, P3D);
  fullScreen(P3D);
  colorMode (RGB, 256);
  background (200);

  line_num = 600;
  box_num = 600;

  offsetx = width / 2;
  offsety = height / 2;
  offsetz = 0.0;

  px = offsetx;
  py = offsety;
  pz = offsetz;

  ampx = 0.0;
  ampy = 0.0;
  ampz = 4000.0;

  pn_time = 0.0;
}

void draw () {
  background (200);

  //lights ();
  ambientLight (102, 102, 102);
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, 0, 0, -1);

  pz -= 40.0;
  px = ampz * noise (pz / 200000.0, pn_time);
  py = 0.0;

  dx = px + random (-1000, 1000);
  dy = py + random (-1000, 1000);
  dz = pz;

  pn_time += 0.01;

  lines.add (new LineObject (px, py, pz, dx, dy, dz));

  if (lines.size () > line_num) {
    lines.remove (0);
  }
  if (lines.size () > 80){
    tlx = offsetx;
    tly = offsety;
    tlz = offsetz;

    float pcamx = lines.get (lines.size () - 60).px;
    float pcamy = lines.get (lines.size () - 60).py;
    float pcamz = lines.get (lines.size () - 60).pz;

    float ncamx = lines.get (lines.size () - 20).px;
    float ncamy = lines.get (lines.size () - 20).py;
    float ncamz = lines.get (lines.size () - 20).pz;

    // camera(視点X, 視点Y, 視点Z, 中心点X, 中心点Y, 中心点Z, 天地X, 天地Y, 天地Z);
    camera (pcamx + offsetx, pcamy + offsety - 60, pcamz + offsetz,
            ncamx + offsetx, ncamy + offsety - 60, ncamz + offsetz,
            0.0, 1.0, 1.0);

    translate (tlx, tly, tlz);

    for (int i = 0; i < lines.size () - 1; i++) {
      if (i > 0) {
        stroke (100);
        strokeWeight (1);
        stx = lines.get (i).px;
        sty = lines.get (i).py;
        stz = lines.get (i).pz;
        enx = lines.get (i - 1).px;
        eny = lines.get (i - 1).py;
        enz = lines.get (i - 1).pz;
        dtx = lines.get (i).dx;
        dty = lines.get (i).dy;
        dtz = lines.get (i).dz;
        beginShape ();
        vertex (stx - 10, sty, stz);
        vertex (enx - 10, eny, enz);
        vertex (enx + 10, eny, enz);
        vertex (stx + 10, sty, stz);
        endShape ();
      }
    }

    strokeWeight (1);

    stroke (180);
    line (-10000, -20, pz - 1000, 10000, -20, pz - 1000);
    stroke (140);
    line (-10000, 0, pz - 1000, 10000, 0, pz - 1000);
    stroke (180);
    line (-10000, 20, pz - 1000, 10000, 20, pz - 1000);

    for (int i = 0; i < 10; i++) {
      color c = color (random (256), random (256), random (256));
      boxes.add (new BoxObject (px + random (-300, 300), py + random (-300, 300), pz, 0, random (10, 60), random (10, 60), random (10, 60), c));
    }

    for (BoxObject b: boxes) {
      b.drawBox ();
    }

    if (boxes.size () > box_num) {
      for (int i = 0; i < 10; i++) {
        boxes.remove (0);
      }
    }
  }
  //saveFrame ();
}

class LineObject {
  float px, py, pz;
  float dx, dy, dz;

  LineObject (float px, float py, float pz, float dx, float dy, float dz) {
    this.px = px;
    this.py = py;
    this.pz = pz;
    this.dx = dx;
    this.dy = dy;
    this.dz = dz;
  }
}

class BoxObject {
  float alpha;

  float box_sizex;
  float box_sizey;
  float box_sizez;
  float box_locx;
  float box_locy;
  float box_locz;

  color col;

  BoxObject (float x, float y, float z, float a, float sx, float sy, float sz, color c) {
    alpha = a;

    box_sizex = sx;
    box_sizey = sy;
    box_sizez = sz;
    box_locx = x;
    box_locy = y;
    box_locz = z;

    col = c;
  }

  void drawBox () {
    alpha += 3.2;

    fill (col, alpha * 1.8);
    stroke (0, alpha);
    strokeWeight (alpha / 140);

    pushMatrix ();
    translate (box_locx, box_locy, box_locz);
    box (box_sizex, box_sizey, box_sizez);
    popMatrix ();
  }
}
