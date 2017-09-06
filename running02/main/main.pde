// see: http://qiita.com/v_ohji/items/d566b29fca13ba8409fb

int line_num;
int count;

float px, py, pz;
float dx, dy, dz;

float ampx, ampy, ampz;

float pn_time;

float offsetx;
float offsety;
float offsetz;
float offsetd;

float tlx, tly, tlz;
float stx, sty, stz;
float enx, eny, enz;
float dtx, dty, dtz;

ArrayList<LineObject> lines = new ArrayList<LineObject> ();
ArrayList<BranchGrow> trees = new ArrayList<BranchGrow> ();

void setup () {

    size (1920, 1080, P3D);
    colorMode (RGB, 256);
    background (200);

    line_num = 2000;

    offsetx = width / 2;
    offsety = height / 2;
    offsetz = 0.0;
    offsetd = -90.0;

    px = offsetx;
    py = offsety;
    pz = offsetz;

    ampx = 0.0;
    ampy = 0.0;
    ampz = 4000.0;

    pn_time = 0.0;

    count = 0;

}

void draw () {

    background (200);

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
                stroke (100);
                strokeWeight (4);
                //point (dtx, dty, dtz);
            }
        }

        strokeWeight (1);

        stroke (180);
        line (-10000, -20, pz - 1000, 10000, -20, pz - 1000);
        stroke (140);
        line (-10000, 0, pz - 1000, 10000, 0, pz - 1000);
        stroke (180);
        line (-10000, 20, pz - 1000, 10000, 20, pz - 1000);

        count += 1;

        if (count % 2 == 0) {
            trees.add (new BranchGrow (px + random (-300, 300), py, pz, 0));
        }

        for (BranchGrow b: trees) {
            b.drawTree ();
        }

        if (trees.size () > 30) {
            trees.remove (0);
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

class BranchGrow {

    int count;

    int step;

    float alpha;

    float tr_scale;
    float tr_angle;
    float tr_length;
    float tr_startd;
    float tr_startx;
    float tr_starty;
    float tr_startz;

    int[] c;
    int[] w;

    float[] nx;
    float[] ny;
    float[] nz;
    float[] px;
    float[] py;
    float[] pz;

    BranchGrow (float x, float y, float z, float a) {

        count = 0;

        step = 10;

        alpha = a;

        tr_scale = 0.98;
        tr_angle = 32.0;
        tr_length = 30.0;
        tr_startd = 0.0;
        tr_startx = x;
        tr_starty = y;
        tr_startz = z;

        c = new int[int (pow (2, step)) * 2];
        w = new int[int (pow (2, step)) * 2];

        nx = new float[int (pow (2, step)) * 2];
        ny = new float[int (pow (2, step)) * 2];
        nz = new float[int (pow (2, step)) * 2];
        px = new float[int (pow (2, step)) * 2];
        py = new float[int (pow (2, step)) * 2];
        pz = new float[int (pow (2, step)) * 2];

        createTree (tr_startx, tr_starty, tr_startz, tr_length, tr_startd, step);

    }

    void createTree (float x01, float y01, float z01, float len, float deg, int n) {

        int c = int (500 / (n + 1));
        int w = int ((n + 1) / 3);

        float x02 = x01 + len * cos (radians (deg + offsetd));
        float y02 = y01 + len * sin (radians (deg + offsetd));
        float z02 = z01 + random (-30, 30);

        savePoints (x02, y02, z02, x01, y01, z01, c, w);

        if (n > 0) {

            float deg01 = random (-tr_angle, tr_angle);
            float scl01 = random (random (10, 20), len * tr_scale);
            createTree (x02, y02, z02, scl01, deg + deg01, n - 1);

            float deg02 = random (-tr_angle, tr_angle);
            float scl02 = random (random (10, 20), len * tr_scale);
            createTree (x02, y02, z02, scl02, deg + deg02, n - 1);

        }

    }

    void savePoints (float x01, float y01, float z01, float x02, float y02, float z02, int c, int w) {

        this.c[count] = c;
        this.w[count] = w;

        nx[count] = x02;
        ny[count] = y02;
        nz[count] = z02;
        px[count] = x01;
        py[count] = y01;
        pz[count] = z01;

        count += 1;

    }

    void drawTree () {

        alpha += 3.2;

        for (int i = 0; i < count; i++) {

            stroke (c[i], alpha);
            strokeWeight (w[i]);

            line (nx[i], ny[i], nz[i], px[i], py[i], pz[i]);

        }

    }

}
