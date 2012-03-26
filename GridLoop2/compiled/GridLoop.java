import processing.core.*; 
import processing.xml.*; 

import processing.video.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class GridLoop extends PApplet {

/**
 * Loop. 
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 */



Movie myMovie;
Movie myMovie2;
Movie[][] myMovies;

public void setup() {
  size(640, 480, P2D);
  background(0);
  // Load and play the video in a loop
	
	for (int i = 0; i<20; i++){
		for (int j = 0; j<20; j++){
		 myMovies[i][j] = new Movie(this, "station.mov");
		}
	}
	

}
public void movieEvent(Movie myMovie) {
  myMovie.read();
}

public void draw() {
	//unit size
	int uz = myMovie.width/1;
	
	//unit's corner where mouse on	
	int mux = mouseX-mouseX%myMovie.width;
	int muy = mouseY-mouseY%myMovie.height;
	
		for (int i = 0; i<20; i++){
			for (int j = 0; j<20; j++){
				if(myMovies[i][j].available()){
					myMovies[i][j].loop();
					if (i == mux-1 || i == mux+1){				//for cubes next to on-cube
						myMovies[i][j].speed(0.2f);
						image(myMovies[i][j], i*uz, j*muy);
						}else if (i == mux) {									//for on-cube
						myMovies[i][j].speed(0.5f);
						image(myMovies[i][j], i*uz, j*muy);
					}
				}
			}
		}
	

	println(myMovies[3][3]);
//	myMovie[3][3].loop();
//	image(myMovie[3][3], 3*uz, 3*muy);
}


public void slowplay() {

}

public void normalplay(){
//		myMovie.speed(1);
//		image(myMovie, mux-uz, muy);
}

/*
void mousePressed(){
  myMovie.stop();
  myMovie.play();
}
*/
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "GridLoop" });
  }
}
