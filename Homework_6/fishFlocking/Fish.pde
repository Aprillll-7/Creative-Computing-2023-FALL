class Fish {
 
  float x, y;
  float xv = random(-1, 1), yv = random(-1, 1);
  float tailStep = 0, tailSpeed = random(2, 3);
  color bodyColor = color(random(255), random(255), random(255));
  color tailColor = color(random(255), random(255), random(255));
 
  float s = random(.05, .2);
  
  // Bezier points///////
  float sx = -90, sy = 0;
 
  float ax = -40, ay = 0;
  float bx = 5, by = 40;
 
  float cx = -40, cy = 0;
  float dx = 5, dy = -40;
 
  float ex = 10, ey = 0;
  
  // Oscillating body points
  float bodyOffset = 0;
  float bodyAmplitude = 10;
  float bodyFrequency = 0.1;
  
  // Fins points
  float finSize = 20;
  float finOffset = 10;

  float animOff = random(TWO_PI);
  ////////////////////////
 
  Fish(float x, float y){
    this.x = x;
    this.y = y;
  }
 
  void update(){
    this.tailStep += this.tailSpeed;
    
    this.xv += (  noise(  this.x * 0.01 + PI, this.y * 0.01, millis() * 0.00002  ) * 2 - 1  ) * 0.3;
    this.yv += (  noise(  this.x * 0.01 - PI, this.y * 0.01, millis() * 0.00002  ) * 2 - 1  ) * 0.3;

    this.xv = constrain(this.xv, -2, 2);
    this.yv = constrain(this.yv, -2, 2);
 
    this.x += this.xv;
    this.y += this.yv;
 
    drawFish();
 
    if(this.x < -10){
      this.x = width + 10;
    }
    else if(this.x > width + 10){
      this.x = -10;
    }
 
    if(this.y < -10){
      this.y = height + 10;
    }
    else if(this.y > height + 10){
      this.y = -10;
    }
  }
 
  void drawFish(){
    sy = 60 * sin( this.tailStep * 0.1 + this.animOff);
    bodyOffset = bodyAmplitude * sin(millis() * 0.001 * bodyFrequency);

    pushMatrix();
    translate(this.x, this.y);
    scale(this.s, this.s);
    rotate(atan2(this.yv, this.xv));
 
    // Colorful Body
    fill(bodyColor);
    bezier(this.sx, this.sy - bodyOffset, this.ax, this.ay, this.bx, this.by, this.ex, this.ey - bodyOffset);
    bezier(this.sx, this.sy - bodyOffset, this.cx, this.cy, this.dx, this.dy, this.ex, this.ey - bodyOffset);
    fill(tailColor);
    
    // Tail
    line(this.sx, this.sy - bodyOffset, this.ex, this.ey - bodyOffset);
    
    // Fins
    drawFins();
    
    popMatrix();
  }

  void drawFins(){
    // Top Fin
    triangle(ex - finOffset, ey - bodyOffset, ex + finSize - finOffset, ey - bodyOffset - finSize, ex - finSize - finOffset, ey - bodyOffset - finSize);

    // Bottom Fin
    triangle(ex - finOffset, ey - bodyOffset, ex + finSize - finOffset, ey - bodyOffset + finSize, ex - finSize - finOffset, ey - bodyOffset + finSize);
  }
}
