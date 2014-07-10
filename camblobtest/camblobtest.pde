import processing.video.*;
Capture cam;

int x = 400;
int y = 400;

void setup () {
  
  size (x, y);
  
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image (cam, 0, 0);
  loadPixels();
  int dimension = x * y;
  //print (cam.width + " " + cam.height + "\n");
  //print (pixels [0]);
  for (int i = 1; i < dimension - 1; i += 1) { 
    if ( //abs (grayscale( pixels[i]) - grayscale (pixels[i+1])) > 5) {
      border (i, 15)) {
      //if (pixels[i] != color (234, 23, 123)) {
        pixels[i] = color(0);
      //}     
    }
  } 
  for (int i = 0; i < dimension - 1; i += 1) { 
    if (pixels [i] != color (0)) {
      //if (pixels[i] != color (234, 23, 123)) {
        pixels[i] = color(250);   
      //}
    }
  } 
  updatePixels();
}

int grayscale (color c ) {
  String t = hex(c);
  int R = int (unhex (t.substring (2,4)));
  int G = int (unhex (t.substring (4,6)));
  int B = int (unhex (t.substring (6)));
  int gs = (R + G + B)/3;
  return gs;
}

boolean border (int i, int j) {
  if ( i > x && i%x != 1 && i%x != 0 && i < x*y-x) {
    float top = abs (grayscale (pixels [i-x]));
    float bottom = abs (grayscale (pixels [i+x]));
    float right = abs (grayscale (pixels [i+1]));
    float left = abs (grayscale (pixels [i-1]));
    float c = sqrt (sq (right - left) + sq (top - bottom));
    return c < j;
  }
  return false;
}
