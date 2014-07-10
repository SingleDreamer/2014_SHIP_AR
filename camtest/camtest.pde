
import processing.video.*;
int picNum = 1;

int x = 640;
int y = 480;

Capture cam;

PImage img;

void setup() {
  //img = loadImage ("kaitou-kid-7.png");
  size(x, y);
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
  //image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  //image (img, 0, 0);
  /*color c = get(mouseX, mouseY);
  String t = hex(c);
  int R = int (unhex (t.substring (2,4)));
  int G = int (unhex (t.substring (4,6)));
  int B = int (unhex (t.substring (6)));
  int gs = (R + G + B)/3;
  */
  //print (t + "\n");
  //print(t + " " + t.substring (2, 4)+ " " + t.substring (4, 6) + " " + t.substring (6) + "\n");
  //print (R + " " + G + " " + B + "\n");
  /*for (int i = 0; i < 960; i++) {
    for (int j = 0; j < 720; j++) {
      color c1 = get(i, j);
      String t1 = hex(c1);
      int R1 = int (unhex (t1.substring (2,4)));
      int G1 = int (unhex (t1.substring (4,6)));
      int B1 = int (unhex (t1.substring (6)));
      int gs1 = (R1 + G1 + B1)/3;
      set (i, j, color (gs1));
    }
  }*/
  //print (gs + "\n");
  /*for (int i = 1; i < 960; i++) {
    for (int j = 1; j < 720; j++) {
      if ( abs (grayscale (get (i, j)) - grayscale (get (i, j + 1))) > 20) {
        set (i, j, color (250));
      }
    }
  }*/
  
  image (cam, 0, 0);

  loadPixels();
  int dimension = x * y;
  //print (cam.width + " " + cam.height + "\n");
  //print (pixels [0]);
  for (int i = 1; i < dimension - 1; i += 1) { 
    if ( abs (grayscale( pixels[i]) - grayscale (pixels[i+1])) > 20) {
      pixels[i] = color(0);   
    }
  } 
  for (int i = 0; i < dimension - 1; i += 1) { 
    if (pixels [i] != color (0)) {
      pixels[i] = color(250);   
    }
  } 
  updatePixels();
  
  //image (cam, 0, 0);
  /*for (int i = 1; i < 960; i++) {
    for (int j = 1; j < 720; j++) {
      if (get (i,j) != color (0)) {
        set (i,j, color (250));
      }
    }
  }*/
}

int grayscale (color c ) {
  String t = hex(c);
  int R = int (unhex (t.substring (2,4)));
  int G = int (unhex (t.substring (4,6)));
  int B = int (unhex (t.substring (6)));
  int gs = (R + G + B)/3;
  return gs;
}
  
/*void keyPressed() {
  saveFrame("screen-"+picNum+".png");
  picNum++;
}*/
