import processing.video.*;
import ddf.minim.*;
import controlP5.*;

Capture cam;
PImage img;
Movie myVideo;
Minim minim;
AudioPlayer player;
ControlP5 cp5;

int slColor = color(255, 255, 255);  // Initial background color
int currentMode = 0;

boolean isCameraLoaded = false;
boolean isImageLoaded = false;
boolean isVideoLoaded = false;

float tiles = map (mouseX, 0, width, 0, 200); // Change the density of the dots accoring to mouse movement on the X axis
float tileSize = width / tiles;
float size = map (mouseY, 0, height, 1, 50); // Change the size of the dots accoring to mouse movement on the Y axis

float v = 1.0 / 9.0;
float[][] kernel1 = {{ v, v, v },
                    { v, v, v },
                    { v, v, v }};
float[][] kernel2 = {{ -1, -1, -1},
                    { -1,  8, -1},
                    { -1, -1, -1}};

void setup() {
  //size(640, 480);
  fullScreen(P3D);
  background(0);
  
  resourcePrepare();
  effectPrepare();
  
  // UI 总
  cp5 = new ControlP5(this, createFont("微软雅黑", 14));
  int sliderWidth = 300;
  int sliderHeight = 30;
  
  // UI: Camera   
  cp5.addToggle("cameraLoad")
    .setPosition(20, 20)
    .setSize(sliderWidth/3, sliderHeight)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
  
  // UI: Image 
  cp5.addToggle("imageLoad")
    .setPosition(20, 60)
    .setSize(sliderWidth/3, sliderHeight)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
  
  // UI: Video
  cp5.addToggle("videoLoad")
    .setPosition(20, 100)
    .setSize(sliderWidth/3, sliderHeight)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
    
  // UI: Music
  cp5.addButton("play").setValue(128).setPosition(10, 10).setSize(50, 19);
  cp5.addButton("pause").setValue(128).setPosition(70, 10).setSize(50, 19);
  cp5.addButton("end").setValue(128).setPosition(130, 10).setSize(50, 19);

  // UI: ColorPicker element
  cp5.addColorPicker("backgroundColor")
    .setPosition(20, height-20)
    .setSize(sliderWidth/3, sliderHeight*4)
    .setColorValue(slColor)
    .setLabel("Selected Color");

  //listbox
  ListBox effectListBox = cp5.addListBox("effect")
    .setPosition(20, 140)
    .setSize(sliderWidth/3, sliderHeight)
    .addItem("grid", 1)
    .addItem("blur", 2)
    .addItem("sharpen", 3);
  
  effectListBox.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      int selectedItem = (int) theEvent.getController().getValue();
      effectDraw(selectedItem);
    }
  });
}

void resourcePrepare() {
  //camera
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }
  //uploaded image
  img = loadImage("example.png");
  //uploaded video
  myVideo = new Movie(this, "example.mp4");
  //upload music
  minim = new Minim(this);
  player = minim.loadFile("example.mp3");
}

void effectPrepare() {
  //smooth (8);
  sphereDetail (3);
}

void draw() {
  resourceDraw();
  //effectDraw();
  //background(bgColor);  // Set background color based on the selected color
}

//ColorPicker
void backgroundColor (int c) {
  slColor = c; // Update the background color based on the selected color
}

void controlEvent(ControlEvent event) {
  if (event.isFrom("cameraLoad")) {
    isCameraLoaded = event.getController().getValue() == 1;
    println("Camera State: " + isCameraLoaded);
  }

  if (event.isFrom("imageLoad")) {
    isImageLoaded = event.getController().getValue() == 1;
    println("Image State: " + isImageLoaded);
  }

  if (event.isFrom("videoLoad")) {
    isVideoLoaded = event.getController().getValue() == 1;
    println("Video State: " + isVideoLoaded);
  }
}

void resourceDraw () {
  if (isCameraLoaded && cam.available()) {
    cam.read();
    image(cam, 0, 0, width, height);
  }

  if (isImageLoaded) {
    image(img, 0, 0, width, height);
  }

  if (isVideoLoaded) {
    image(myVideo, 0, 0, width, height);
  }
}


// Callback function for the toggle button
void videoLoad(boolean value) {
  if (value) {
    // Load the video when the toggle is turned on
    myVideo.play();
    isVideoLoaded = true;
  } else {
    // Stop the video when the toggle is turned off
    myVideo.stop();
    isVideoLoaded = false;
  }
}

//music
void play() {
  if (!player.isPlaying()) {
    player.play();
  }
}

void pause() {
  if (player.isPlaying()) {
    player.pause();
  }
}

void end() {
  if (player.isPlaying()) {
    player.pause();
    player.rewind();
  }
}

void effectDraw(int currentMode) {
  switch (currentMode) {
    case 1:
      translate (width/2, height/2);
      effectGrid(); 
      //break;
    case 2:
      translate (width/2, height/2);
      effectBlur();
      //break;
    case 3:
      effectSharpen();
      //break;
    case 4:
      fill(0);
      //break;
  }
}

void effectGrid () {
  rotateY (radians(frameCount)*0.5); 

  for (int x=0; x<tiles; x++) {
    for (int y=0; y<tiles; y++) {
      color c = img.get(int(x * tileSize), int(y * tileSize));
      float b = map (brightness (c), 0, 255, 1, 0);
      
      push();
      translate(x * tileSize - width/2, y * tileSize - width/2);
      
      sphere(tileSize * b * 0.9);
      pop();

    }
  }
}

void effectBlur () {
  img.loadPixels();

  // Create an opaque image of the same size as the original
  PImage blurImg = createImage(img.width, img.height, RGB);

  // Loop through every pixel in the image
  for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
      float sumRed = 0;   // Kernel sums for this pixel
      float sumGreen = 0;
      float sumBlue = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);

          // Process each channel separately, Red first.
          float valRed = red(img.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sumRed += kernel1[ky+1][kx+1] * valRed;

          // Green
          float valGreen = green(img.pixels[pos]);
          sumGreen += kernel1[ky+1][kx+1] * valGreen;

          // Blue
          float valBlue = blue(img.pixels[pos]);
          sumBlue += kernel1[ky+1][kx+1] * valBlue;
        }
      }
      // For this pixel in the new image, set the output value
      // based on the sum from the kernel
      blurImg.pixels[y*blurImg.width + x] = color(sumRed, sumGreen, sumBlue);
    }
  }
  // State that there are changes to blurImg.pixels[]
  blurImg.updatePixels();

  image(blurImg, width/2, 0); // Draw the new image
}

void effectSharpen () {
  img.loadPixels();

  // Edge detection should be done on a grayscale image.
  //  Create a copy of the source image, and convert to gray.
  PImage grayImg = img.copy();
  grayImg.filter(GRAY);
  // grayImg.filter(BLUR);

  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(grayImg.width, grayImg.height, RGB);

  // Loop through every pixel in the image
  for (int y = 1; y < grayImg.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < grayImg.width-1; x++) {  // Skip left and right edges
      // Output of this filter is shown as offset from 50% gray.
      // This preserves transitions from low (dark) to high (light) value.
      // Starting from zero will show only high edges on black instead.
      float sum = 128;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*grayImg.width + (x + kx);

          // Image is grayscale, red/green/blue are identical
          float val = blue(grayImg.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel2[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the output value
      // based on the sum from the kernel
      edgeImg.pixels[y*edgeImg.width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();

  image(edgeImg, width/2, 0); // Draw the new image
}
//camera
//void cameraLoad (boolean theFlag) {
//  if (theFlag==true) {
//    camera = true;
//  } else {
//    camera = false;
//  }
//}

////image
//void imageLoad (boolean theFlag) {
//  if (theFlag==true) {
//    isImageLoaded = true;
//  } else {
//    isImageLoaded = false;
//  }
//}

////video
//void movieEvent(Movie m) {
//  // Read new frames from the video when available
//  m.read();
//}


  
