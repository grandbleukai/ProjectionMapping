/**
 * Loop. 
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
*/

import processing.video.*;

Movie[][] myMovies;

void setup() {
  size(640, 480, P2D);
  background(0);
	myMovies = new Movie[20][20];
	for (int i = 0; i<20; i++){
		for (int j = 0; j<20; j++){
			myMovies[i][j] = new Movie(this, "station.mov");
		}
	}
}

void movieEvent(Movie myMovie) {
	for (int i = 0; i<20; i++){
		for (int j = 0; j<20; j++){
			myMovies[i][j].read();
		}
	}
}

void draw() {
	for (int i = 0; i<20; i++){
		for (int j = 0; j<20; j++){
			myMovies[i][j].loop();
			}
		}
	image(myMovies[1][1],40,40);
}

/*
void mousePressed(){
  myMovie.stop();
  myMovie.play();
}
*/