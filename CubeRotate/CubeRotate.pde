/**
  @file CubeRotate
  @brief Cube on which Mouse Pointer is, rotates.
  @author Kenichi Yorozu
  @date 13th March 2012
 */

import processing.opengl.*;

float boxSize = 40;
color boxFill;

//Camera Properties
float camZoom = 130.0f;
float camRotX = 0.0f;
float camRotY = 0.0f;
float camTX = 0.0f;
float camTY = 0.0f;
//Mouse Properties
int lastX = 0;
int lastY = 0;
int nowX = 0;
int nowY = 0;
boolean[] Buttons = {false, false, false};

void setup(){
  //size(800, 800, P3D);      //Use processing 3D
  size(800, 800, OPENGL);  //Use OpenGL
  noStroke();
}

void draw(){
  background(0);
  lights();
  //Update Camera
  translate(camTX + width/2, camTY + height/2, -camZoom);
  rotateX(camRotX);
  rotateY(camRotY);
  
  //About Lights - See http://r-dimension.xsrv.jp/classes_j/5_interactive3d/
  //lights();  //Normal Light
  //directionalLight(200, 200, 200, -1, 0, -1);
  //pointLight(200, 200, 200, 0, 0, 0);
  spotLight(200, 200, 200, 400, -400, 400, -1, 1, -1, PI/2, 10);
  //shininess(5.0);
  
  //DrawBoxes
  for(int i = -width / 2; i <= width / 2; i += boxSize){
    translate(i, 0, 0);
    for(int j = -height / 2; j <= height / 2; j += boxSize){
      translate(0, j, 0);
      //Rotate Object
      if(i + boxSize >= nowX && i <= nowX && j + boxSize >= nowY && j <= nowY){
        rotateY(frameCount * 0.1);
      }
      //set Color
      //boxFill = color(abs(i) % 255, abs(j) % 255, abs(i + j) % 25, 255);  //colorful
      boxFill = color(200, 200, 200, 255);
      fill(boxFill);
      box(boxSize, boxSize, boxSize);
      if(i + boxSize >= nowX && i <= nowX && j + boxSize >= nowY && j <= nowY){
        rotateY(-frameCount * 0.1);
      }
      translate(0, -j, 0);
    }
    translate(-i, 0, 0);
  }
  translate(0, 0, boxSize);
  fill(100, 100, 100, 255);
  box(boxSize, boxSize, boxSize);
}

void mousePressed(){
  lastX = mouseX;
  lastY = mouseY;
  
  if(mouseButton == LEFT){
    Buttons[0] = true;
  }else{
    Buttons[0] = false;
  }
  if(mouseButton == CENTER){
    Buttons[1] = true;
  }else{
    Buttons[1] = false;
  }
  if(mouseButton == RIGHT){
    Buttons[2] = true;
  }else{
    Buttons[2] = false;
  }
  
}

void mouseMoved(){
  nowX = mouseX - width / 2;
  nowY = mouseY - height / 2;
}

void mouseDragged(){
  int diffX = mouseX - lastX;
  int diffY = mouseY - lastY;
  lastX = mouseX;
  lastY = mouseY;
  
  if( Buttons[1] ){
    camZoom -= (float) 0.5f * diffY;
  }else if(Buttons[0] ){
    camRotX -= (float) 0.01f * diffY;
    camRotY += (float) 0.01f * diffX;
  }else if( Buttons[2] ){
    camTX += (float) 0.1f * diffX;
    camTY += (float) 0.1f * diffY;
  }
}
