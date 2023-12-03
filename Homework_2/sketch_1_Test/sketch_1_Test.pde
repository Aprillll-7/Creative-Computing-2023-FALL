float x,y,tempX,tempY;
float a,b,c,d;
float scale=0.23;
int n=10000;
int i;

void setup () {
  fullScreen();
  background (255);
  stroke(0,15);
  x=random(-1,1);
  y=random(-1,1);
  a=random(-2*PI,2*PI);
  b=random(-2*PI,2*PI);
  c=random(-2*PI,2*PI);
  d=random(-2*PI,2*PI);  //test at which value the overall effect is best
}

void draw () {
  x+=0.001;
  y+=0.001;
  for (i=0; i<n; i++) {
    tempX=sin(a*y)-cos(b*x);
    tempY=sin(c*x)-cos(d*y);
    point (width*(0.5+x*scale), height*(0.735+y*scale*1.5));
    x=tempX;
    y=tempY;
  }
}

void mousePressed () {
  save ("img_"+a+"_"+b+"_"+c+"_"+d+".jpg");
  background (255);
  setup ();
}
