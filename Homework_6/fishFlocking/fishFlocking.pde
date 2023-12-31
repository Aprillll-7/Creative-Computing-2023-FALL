int fishNum = 200;
Fish[] fish = new Fish[fishNum];
boolean mouseDown = false;

void setup() {
  size(1280, 900);
  
  for (int i = 0; i < fishNum; i++) {
    fish[i] = new Fish(random(width), random(height));
  }
}

void mousePressed() {
  mouseDown = true;
}

void mouseReleased() {
  mouseDown = false;
}

void draw() {
  // Create a dreamy underwater background
    drawUnderwaterBackground();

  // Update and draw fish
  for (int i = 0; i < fishNum; i++) {
    fish[i].update();
  }

  // Fish interactions
  for (int i = 0; i < fishNum - 1; i++) {
    for (int c = i + 1; c < fishNum; c++) {
      float d = dist(fish[i].x, fish[i].y, fish[c].x, fish[c].y) + 1;

      if (d <= 15) {
        fish[i].xv += .004 * (fish[i].x - fish[c].x);
        fish[i].yv += .004 * (fish[i].y - fish[c].y);

        fish[c].xv += .004 * (fish[c].x - fish[i].x);
        fish[c].yv += .004 * (fish[c].y - fish[i].y);
      } else if (d > 50 && d <= 80) {
        fish[i].xv -= .000005 * (fish[i].x - fish[c].x);
        fish[i].yv -= .000005 * (fish[i].y - fish[c].y);

        fish[c].xv -= .000005 * (fish[c].x - fish[i].x);
        fish[c].yv -= .000005 * (fish[c].y - fish[i].y);

        fish[i].xv += ((fish[c].xv + fish[i].xv) / 2 - fish[i].xv) * 0.01;
        fish[i].yv += ((fish[c].yv + fish[i].yv) / 2 - fish[i].yv) * 0.01;
      }

      if (!mouseDown) {
        float d2 = dist(mouseX, mouseY, fish[i].x, fish[i].y);
        if (d2 < 100) {
          fish[i].xv -= .002 * (mouseX - fish[i].x) / d2;
          fish[i].yv -= .002 * (mouseY - fish[i].y) / d2;
        }
      }
      if (mouseDown) {
        float d2 = dist(mouseX, mouseY, fish[i].x, fish[i].y);
        if (d2 < 150) {
          fish[i].xv += .002 * (mouseX - fish[i].x) / d2;
          fish[i].yv += .002 * (mouseY - fish[i].y) / d2;
        }
      }
    }
  }
}

void drawUnderwaterBackground() {
  // Gradient background
  int gradientTop = color(0, 102, 204); // Light blue
  int gradientBottom = color(26, 35, 126); // Darker blue
  background(gradientTop);
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    int c = lerpColor(gradientTop, gradientBottom, inter);
    stroke(c);
    line(0, y, width, y);
  }

  // Add some texture or other elements to enhance the underwater feel
  // You can experiment with adding seaweed, bubbles, or other details.
  // For simplicity, I'll add some noise to simulate water texture.
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float n = noise(x * 0.01, y * 0.01);
      float alpha = map(n, 0, 1, 50, 150);
      int currentColor = pixels[x + y * width];
      int blendedColor = lerpColor(currentColor, color(0, alpha), 0.2);
      pixels[x + y * width] = blendedColor;
    }
  }
  updatePixels();
}
