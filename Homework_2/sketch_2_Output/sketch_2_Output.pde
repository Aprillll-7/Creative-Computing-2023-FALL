float x,y,tempX,tempY;
float a,b,c,d;
float scale=0.23;
int n=10000;
int i;
boolean status = false;

void setup () {
  fullScreen();
  background (255);
  stroke(0,15);
  x=random(-1,1);
  y=random(-1,1);
  //Set the value of a, b, c, and d by comparing the shorcuts in 1_test
  a=2.4093504;
  b=-6.1879926;
  c=-1.1392665;
  d=0.68303823;
  status = !status;// start the process
}

void draw () {
  x+=0.001;
  y+=0.001;
  if (status) {
    for (i=0; i<n; i++) {
      tempX=sin(a*y)-cos(b*x);
      tempY=sin(c*x)-cos(d*y);
      point (width*(0.5+x*scale), height*(0.735+y*scale*1.5));
      x=tempX;
      y=tempY;
    saveFrame("frames/####.tif"); // make video through Processing->Tool->Movie Maker
    }
  }
}

void mousePressed() {
  println("Recording stopped.");
  setup ();
}
