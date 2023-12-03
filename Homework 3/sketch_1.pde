//定义Rect类来实现边缘粗细的设置（太细了不好看）
class Rect {
  float x, y, w, h;

  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void draw() {
    stroke(0);
    strokeWeight(3);
    rect(x, y, w, h);
  }
}

//初始设置
void setup() {
  size(600, 600);
  background(255);
  drawMondrian(new Rect(50, 50, 500, 500), 6);
  //noLoop();
}

void draw() {
  //drawMondrian(new Rect(50, 50, 500, 500), 6);
}

//点击鼠标可以刷新
void mousePressed(){
  clear();
  drawMondrian(new Rect(50, 50, 500, 500), 6);
}

//设置drawMondrian函数
void drawMondrian(Rect rect, int depth) {
  if (depth == 0) {
    fill(randomColor());
    rect.draw();
  } else {
    float randomChoice = random(1);
    if (randomChoice < 1.0/3.0) {
      Rect[] splitRects = splitX(rect);
      for (Rect r : splitRects) {
        drawMondrian(r, depth - 1);
      }
    } else if (randomChoice < 2.0/3.0) {
      Rect[] splitRects = splitY(rect);
      for (Rect r : splitRects) {
        drawMondrian(r, depth - 1);
      }
    } else {
      fill(randomColor());
      rect.draw();
    }
  }
}

//X轴的分割
Rect[] splitX(Rect rect) {
  float a = random(rect.x + 1, rect.x + rect.w - 1);
  return new Rect[] {
    new Rect(rect.x, rect.y, a - rect.x, rect.h),
    new Rect(a, rect.y, rect.x + rect.w - a, rect.h)
  };
}

//y轴的分割
Rect[] splitY(Rect rect) {
  float a = random(rect.y + 1, rect.y + rect.h - 1);
  return new Rect[] {
    new Rect(rect.x, rect.y, rect.w, a - rect.y),
    new Rect(rect.x, a, rect.w, rect.y + rect.h - a)
  };
}

//颜色风格设置（此处选择经典的红黄蓝黑白配色）
color randomColor() {
  //color[] cols = {color(0, 0, 0), color(238, 237, 237), color(13, 18, 130), color(240, 222, 54), color(215, 19, 19)}; // classical color pattern
  color[] cols = {color(255), color(255, 238, 219), color(255, 216, 204), color(255, 189, 155), color(10, 29, 55)}; // customized color pattern
  //color[] cols = {color(255), color(210, 224, 251), color(249, 243, 204), color(215, 229, 202), color(142, 172, 205)}; // customized color pattern
  //float[] darkenFactors = {0, 0.1, 0.1, 0.15, 0.3};
  int index = (int)random(cols.length);
  //return darken(cols[index], darkenFactors[index]);
  return color(cols[index]);
}

color darken(color col, float factor) {
  float[] rgb = {red(col), green(col), blue(col)};
  for (int i = 0; i < rgb.length; i++) {
    rgb[i] *= (1 - factor);
  }
  return color(rgb[0], rgb[1], rgb[2]);
}

/*

void setup() {
  size(600, 600);
  noLoop();
  drawMondrian(50, 50, 500, 500, 6);
}

void drawMondrian(float x, float y, float w, float h, int depth) {
  if (depth == 0) {
    fill(randomColor());
    rect(x, y, w, h);
  } else {
    float randomChoice = random(1);
    if (randomChoice < 1.0/3.0) {
      float a = random(x + 1, x + w - 1);
      drawMondrian(x, y, a - x, h, depth - 1);
      drawMondrian(a, y, x + w - a, h, depth - 1);
    } else if (randomChoice < 2.0/3.0) {
      float a = random(y + 1, y + h - 1);
      drawMondrian(x, y, w, a - y, depth - 1);
      drawMondrian(x, a, w, y + h - a, depth - 1);
    } else {
      fill(randomColor());
      rect(x, y, w, h);
    }
  }
}

color randomColor() {
  color[] cols = {color(0, 0, 0), color(255), color(255, 255, 0), color(255, 0, 0), color(0, 0, 255)};
  float[] darkenFactors = {0, 0.1, 0.1, 0.15, 0.3};
  int index = (int)random(cols.length);
  return darken(cols[index], darkenFactors[index]);
}

color darken(color col, float factor) {
  float[] rgb = {red(col), green(col), blue(col)};
  for (int i = 0; i < rgb.length; i++) {
    rgb[i] *= (1 - factor);
  }
  return color(rgb[0], rgb[1], rgb[2]);
}


void setup() {
  size(600, 600);
  background(255);
  drawMondrian(50, 50, width - 100, height - 100, 8);
}

void drawMondrian(float x, float y, float w, float h, int depth) {
  if (depth == 0) {
    fill(random(255), random(255), random(255));
    rect(x, y, w, h);
  } else {
    boolean horizontalSplit = random(1) > 0.5;
    float splitPoint = horizontalSplit ? y + random(h * 0.8) : x + random(w * 0.8);

    if (horizontalSplit) {
      drawMondrian(x, y, w, splitPoint - y, depth - 1);
      drawMondrian(x, splitPoint, w, h - (splitPoint - y), depth - 1);
    } else {
      drawMondrian(x, y, splitPoint - x, h, depth - 1);
      drawMondrian(splitPoint, y, w - (splitPoint - x), h, depth - 1);
    }
  }
}


void colorStyle(){

}

void setup() {
  size(600,600);
  rectMode(CORNERS);
}

void draw() {
  background(255);
  noStroke();
  
  // upper right, red rectangle
  fill(230, 20, 20);
  rect(100, 0, 400, 300);
  
  // lower left, blue rectangle 
  fill(40, 20, 200);
  rect(0, 300, 100, 400);
  
  // lower right, yellow rectangle 
  fill(230, 230, 20);
  rect(380, 350, 400, 400);
  
  // black lines
  stroke(0);
  strokeCap(SQUARE);
  strokeWeight(12);
  line(100, 0, 100, 400);
  line(0, 300, 400, 300);
  line(380, 300, 380, 400);
  
  strokeWeight(20);
  line(0, 200, 100, 200);
  line(380, 350, 400, 350);
}*/
