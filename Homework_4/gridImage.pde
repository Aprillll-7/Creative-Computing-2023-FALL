PImage img;
char[] chars = {'@', '#', '8', '&', 'o', ':', '*', '.', ' '};

void setup () {
  size (900, 900, P3D);
  smooth (8);
  sphereDetail (3);
  img = loadImage ("bust.jpg");
  img.resize(width, height);
  textAlign(CENTER, CENTER);
}

void draw () {
  background (#F1F1F1);
  fill (0);
  noStroke ();
  float tiles = map (mouseX, 0, width, 0, 200); // Change the density of the dots accoring to mouse movement on the X axis
  float tileSize = width / tiles;
  float size = map (mouseY, 0, height, 1, 50); // Change the size of the dots accoring to mouse movement on the Y axis
  
  translate (width/2, height/2);
  rotateY (radians(frameCount)*0.5); // For method 1
  
  for (int x=0; x<tiles; x++) {
    for (int y=0; y<tiles; y++) {
      color c = img.get(int(x * tileSize), int(y * tileSize));
      //float b = map (brightness (c), 0, 255, 0, 1);  // Change the range of brightness method 2
      float b = map (brightness (c), 0, 255, 1, 0);  // Change the range of brightness method 1
      //float z = map (b, 1, 0, -100, 100);
      
      push();
      translate(x * tileSize - width/2, y * tileSize - width/2);
      
      //method 1 spheres
      sphere(tileSize * b * 0.9);
      pop();
      
      /*method 2 letters
      int index = int(b * (chars.length - 1));
      char selectedChar = chars[index];
      textSize(size);
      text(selectedChar, 0, 0);
      fill(0, b * 200);
      pop();
      */
    }
  }
}

void keyPressed () {
  save ("img_"+mouseX+"_"+mouseY+".jpg");
}
