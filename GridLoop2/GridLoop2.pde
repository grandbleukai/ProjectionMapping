import processing.video.*;

Movie[] myMovies;

void setup() {
  size(640, 480, P2D);
  background(0);
	myMovies = new Movie[11];
	myMovies[3] = new Movie(this, "cube.mov");
	myMovies[7] = new Movie(this, "station.mov");
//	for (int i = 0; i<10; i++){
//		myMovies[i] = new Movie(this, "station.mov");
//	}

	myMovies[3].loop();
	myMovies[7].loop();
	
}

void movieEvent(Movie myMovie) {

	myMovies[3].read();
	myMovies[7].read();
}

void draw() {
	image(myMovies[3],0,0);
	image(myMovies[7],60,40);
}