 angle += speed; // Update the
  println("angle:;"+angle);
 
  //pos circulo
  float x =  width/1.2 + sin(angle) * radius;
  float y = height/1.2 + cos(angle) * radius;
 
  //parametros circulo principal
  fill(0);
  ellipse(x, y, 1, 1); // Draw smaller circle
 
 
  // Set the position of the large circles based on the
  // new position of the small circle
  float x2 = x + cos(angle * sx) * radius;
  float y2 = y + sin(angle * sy) * radius;
  ellipse(x2, y2, 1, 1); // Draw larger circle
 
  //line
  if(hh<100){
    hh+=1;
  }
  else{
    hh--;
  }
 
//if (angle = 360) {noLoop()};
   
   
 
  col = color(9,9,9+hh,15);
  stroke(devuelveColor(),hh);
  line(x,y,x2,y2);
}
 
 
void limpia(){
  background(0);
}
 
color devuelveColor() {
  float rojo = random (0,900);
  float verde = random(0,900);
  float azul = random(0,900);
  return color(rojo,verde,azul);
}
 
color devuelveColor2() {
  float rojo = random (0,900);
  float verde = random(0);
  float azul = random(0);
  return color(rojo,verde,azul);
}

