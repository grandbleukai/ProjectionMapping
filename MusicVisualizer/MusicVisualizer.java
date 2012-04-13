import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class MusicVisualizer extends PApplet {


 //////////////////////////////////////////////////////////////
 //                                                          //
 //  Music Visualizer                                        //
 //                                                          //
 //  a quick sketch to do WimAmp-style music visualization   //
 //  using Processing and the Minim Library ...              //
 //                                                          //
 //  (c) Martin Schneider 2009                               //
 //                                                          //
 //////////////////////////////////////////////////////////////




Minim minim;

AudioPlayer groove;
AudioRenderer radar, vortex, iso;
AudioRenderer[] visuals; 

int select;
 
public void setup()
{
  // setup graphics
  size(512, 512, P3D);
    
  // setup player
  minim = new Minim(this);
  groove = minim.loadFile("Season.mp3", 1024);
  groove.loop();  

  // setup renderers
  vortex = new VortexRenderer(groove);
  radar = new RadarRenderer(groove);
  iso = new IsometricRenderer(groove);
  
  visuals = new AudioRenderer[] {radar, vortex,  iso};
  
  // activate first renderer in list
  select = 0;
  groove.addListener(visuals[select]);
  visuals[select].setup();
}
 
public void draw()
{
  visuals[select].draw();
}
 
public void keyPressed() {
   groove.removeListener(visuals[select]);
   select++;
   select %= visuals.length;
   groove.addListener(visuals[select]);
   visuals[select].setup();
}

public void stop()
{
  groove.close();
  minim.stop();
  super.stop();
}



/// abstract class for audio visualization

abstract class AudioRenderer implements AudioListener {
  float[] left;
  float[] right;
  public synchronized void samples(float[] samp) { left = samp; }
  public synchronized void samples(float[] sampL, float[] sampR) { left = sampL; right = sampR; }
  public abstract void setup();
  public abstract void draw(); 
}


// abstract class for FFT visualization



abstract class FourierRenderer extends AudioRenderer {
  FFT fft; 
  float maxFFT;
  float[] leftFFT;
  float[] rightFFT;
  FourierRenderer(AudioSource source) {
    float gain = .125f;
    fft = new FFT(source.bufferSize(), source.sampleRate());
    maxFFT =  source.sampleRate() / source.bufferSize() * gain;
    fft.window(FFT.HAMMING);
  }
  
  public void calc(int bands) {
    if(left != null) {
      leftFFT = new float[bands];
      fft.linAverages(bands);
      fft.forward(left);
      for(int i = 0; i < bands; i++) leftFFT[i] = fft.getAvg(i);   
    }
  }
}



// the code for the isometric renderer was deliberately taken from Jared C.'s wavy sketch 
// ( http://www.openprocessing.org/visuals/?visualID=5671 )

class IsometricRenderer extends FourierRenderer {

  int r = 7;
  float squeeze = .5f;

  float a, d;
  float val[];
  int n;
  
  IsometricRenderer(AudioSource source) {
    super(source);
    n = ceil(sqrt(2) * r);
    d = min(width,height) / r / 5;
    val = new float[n];
  }

  public void setup() { 
    colorMode(RGB, 6, 6, 6); 
    stroke(0);
  } 
  
  public void draw() {
    
    if(left != null) {
     
      super.calc(n);
      
      // actual values react with a delay
      for(int i=0; i<n; i++) val[i] = lerp(val[i], pow(leftFFT[i], squeeze), .1f);
      
      a -= 0.08f; 
      background(6);  
      for (int x = -r; x <= r; x++) { 
        for (int z = -r; z <= r; z++) { 
          int y = PApplet.parseInt( height/3 * val[(int) dist(x,z,0,0)]); 
  
          float xm = x*d - d/2; 
          float xt = x*d + d/2; 
          float zm = z*d - d/2; 
          float zt = z*d + d/2; 
  
          int w0 = (int) width/2; 
          int h0 = (int) height * 2/3; 
  
          int isox1 = PApplet.parseInt(xm - zm + w0); 
          int isoy1 = PApplet.parseInt((xm + zm) * 0.5f + h0); 
          int isox2 = PApplet.parseInt(xm - zt + w0); 
          int isoy2 = PApplet.parseInt((xm + zt) * 0.5f + h0); 
          int isox3 = PApplet.parseInt(xt - zt + w0); 
          int isoy3 = PApplet.parseInt((xt + zt) * 0.5f + h0); 
          int isox4 = PApplet.parseInt(xt - zm + w0); 
          int isoy4 = PApplet.parseInt((xt + zm) * 0.5f + h0); 
  
          fill (2); 
          quad(isox2, isoy2-y, isox3, isoy3-y, isox3, isoy3+d, isox2, isoy2+d); 
          fill (4); 
          quad(isox3, isoy3-y, isox4, isoy4-y, isox4, isoy4+d, isox3, isoy3+d); 
  
          fill(4 + y / 2.0f / d); 
          quad(isox1, isoy1-y, isox2, isoy2-y, isox3, isoy3-y, isox4, isoy4-y); 
        } 
      }
    }
  } 

}



class RadarRenderer extends AudioRenderer {
  
  float aura = .25f;
  float orbit = .25f;
  int delay = 2;
  
  int rotations;

  RadarRenderer(AudioSource source) {
    rotations =  (int) source.sampleRate() / source.bufferSize();
  }
  
  public void setup() {
    colorMode(RGB, TWO_PI * rotations, 1, 1);
    background(0);
  }
  
  public synchronized void draw()
  {
    if(left != null) {
   
      float t = map(millis(),0, delay * 1000, 0, PI);   
      int n = left.length;
      
      // center 
      float w = width/2 + cos(t) * width * orbit;
      float h = height/2 + sin(t) * height * orbit; 
      
      // size of the aura
      float w2 = width * aura, h2 = height * aura;
      
      // smoke effect
      if(frameCount % delay == 0 ) image(g,0,0, width+1, height+1); 
      
      // draw polar curve 
      float r1=0, a1=0, x1=0, y1=0, r2=0, a2=0, x2=0, y2=0; 
      for(int i=0; i <= n; i++)
      {
        r1 = r2; a1 = a2; x1 = x2; y1 = y2;
        r2 = left[i % n] ;
        a2 = map(i,0, n, 0, TWO_PI * rotations);
        x2 = w + cos(a2) * r2 * w2;
        y2 = h + sin(a2) * r2 * h2;
        stroke(a1, 1, 1, 30);
        // strokeWeight(dist(x1,y1,x2,y2) / 4);
        if(i>0) line(x1, y1, x2, y2);
      }
    }
  }
}


class VortexRenderer extends FourierRenderer {

  int n = 48;
  float squeeze = .5f;

  float val[];

  VortexRenderer(AudioSource source) {
    super(source); 
    val = new float[n];
  }

  public void setup() {
    colorMode(HSB, n, n, n);
    rectMode(CORNERS);
    noStroke();     
  }

  public synchronized void draw() {

    if(left != null) {  
      
      float t = map(millis(),0, 3000, 0, TWO_PI);
      float dx = width / n;
      float dy = height / n * .5f;
      super.calc(n);

      // rotate slowly
      background(0); lights();
      translate(width/2, height, -width/2);
      rotateZ(HALF_PI); 
      rotateY(-2.2f - HALF_PI + PApplet.parseFloat(mouseY)/height * HALF_PI);
      rotateX(t);
      translate(0,width/4,0);
      rotateX(t);

      // draw coloured slices
      for(int i=0; i < n; i++)
      {
        val[i] = lerp(val[i], pow(leftFFT[i] * (i+1), squeeze), .1f);
        float x = map(i, 0, n, height, 0);
        float y = map(val[i], 0, maxFFT, 0, width/2);
        pushMatrix();
          translate(x, 0, 0);
          rotateX(PI/16 * i);
          fill(i, n * .7f + i * .3f, n-i);
          box(dy, dx + y, dx + y);
        popMatrix();
      }
    }
  }
}



  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "MusicVisualizer" });
  }
}
