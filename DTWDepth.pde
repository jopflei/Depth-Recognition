// Jorit Pfleiderer
// Depth thresholding

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import oscP5.*;
import netP5.*;

Kinect kinect;
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress dest;

// Depth image
PImage depthImg;

// Which pixels do we care about?
// These thresholds can also be found with a variaty of methods
float minDepth =  996;
float maxDepth = 2493;

// What is the kinect's angle
float angle;

void setup() {
  size(1280, 480);
  
  oscP5 = new OscP5(this,6449);
  
  dest = new NetAddress("127.0.0.1",6448);
  
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();

  myRemoteLocation = new NetAddress("192.168.1.28", 5002);
  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
}
int numHoriz = 640;
int numVert = 480;
color[] downPix = new color[numHoriz * numVert];

void draw() {
  // Draw the raw image
  image(kinect.getDepthImage(), 0, 0);

  //Calibration
  //minDepth = map(mouseX,0,width, 0, 4500);
  //maxDepth = map(mouseY,0,height, 0, 4500);

  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, kinect.width, 0);
  
  //Comment for Calibration
  fill(0);
  text("TILT: " + angle, 10, 20);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  int boxNum = 0;
  int tot = kinect.width*kinect.height;
  for (int x = 0; x < 640; x += kinect.width) {
     for (int y = 0; y < 480; y += kinect.height) {
        float red = 0, green = 0, blue = 0;
        
        for (int i = 0; i < kinect.width; i++) {
           for (int j = 0; j < kinect.height; j++) {
              int index = (x + i) + (y + j) * 640;
              red += red(depthImg.pixels[index]);
              green += green(depthImg.pixels[index]);
              blue += blue(depthImg.pixels[index]);
           } 
        }
       downPix[boxNum] =  color(red/tot, green/tot, blue/tot);
      // downPix[boxNum] = color((float)red/tot, (float)green/tot, (float)blue/tot);
       fill(downPix[boxNum]);
       
       int index = x + 640*y;
       red += red(depthImg.pixels[index]);
       green += green(depthImg.pixels[index]);
       blue += blue(depthImg.pixels[index]);
      // fill (color(red, green, blue));
       rect(x, y, kinect.width, kinect.height);
       boxNum++;
      /* if (first) {
         println(boxNum);
       } */
     } 
  }
sendOsc(downPix);
  }

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  }
}
void sendOsc(int downPix[]) {
  OscMessage msg = new OscMessage("/wek/inputs");
  println(downPix.length);
  for (int i = 0; i < downPix.length/1000; i++) {
      msg.add(float(downPix[i]));
   }
  oscP5.send(msg, dest);
}
