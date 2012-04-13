float a = -1.4;
float b = 1.6;
float c = 1.0;
float d = 0.7;

float x = 0;
float y = 0;

float preX, preY;

void setup()
{
  background(255);
  size(500,500);
}

void draw(){
  point(100*x+width/2, 100*y+height/2);
  x = (sin(a*preY)+c*cos(a*preX));
  y = (sin(b*preX)+d*cos(b*preY));
  preX = x;
  preY = y;
}