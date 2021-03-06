//make it so can update picture
//add realtime search color 
//arrayindexoutofboundsexception???


import processing.video.*;
Capture cam;


PImage img, edges, blobs, current;
color bg = color(255);
color fg = color(200);
int threshold = 50;
float contrastAdj = 0.4;
int pivot = 255 / 2;
int count, x1, y1, x2, y2;
float r2 = sqrt(2);
ArrayList<Node> sol;
int i;
int currentPlayer = 0; //0: PL; 1: CP
Player PL = new Player();
Computer CP = new Computer();
float[][] kernelLR = {
  {
    1, 0, -1
  }
  , {
    2, 0, -2
  }
  , {
    1, 0, -1
  }
};
float[][] kernelUD = {
  {
    1, 2, 1
  }
  , {
    0, 0, 0
  }
  , {
    -1, -2, -1
  }
};
int[][] buffer, board;
boolean edge, blob;

String currentImage;
//int picNum;

void setup() {
//  picNum = 1;
  
  //size (640, 480); FIX THIS AT SOME POINT
  size(500,500);
  i = 0;
  count = 0;
  edges = createImage(width, height, RGB);
  blobs = createImage(width, height, RGB);
  buffer = new int[width][height];
  board = new int[width][height];

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
    cam = new Capture(this, cameras[1]);
    cam.start();
    
    turn();
  }
}

void turn(){
  if(currentPlayer==0){
    PL.turn();
  }
  else{
    CP.turn();
  }
}

void draw() {
  if (count == 0) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
  } else if (count == 1) {

//    img = loadImage(currentImage);
    //size(img.width, img.height);
    //    edges = createImage(width, height, RGB);
    //    blobs = createImage(width, height, RGB);
    //    buffer = new int[width][height];
    //    board = new int[width][height];
    img = loadImage ("test.png");
    drawEdges();
    image(edges, 0, 0);
    fillBoard();
  } else if (count == 2) {
    drawEdges();
    image(edges, 0, 0);
    fillBoard();
    ellipseMode(CENTER);
    noStroke();
    fill(0, 255, 0, 128);
    ellipse(x1, y1, 10, 10);
  } else if (count == 3) {
    drawEdges();
    image(edges, 0, 0);
    fillBoard();
    ellipseMode(CENTER);
    noStroke();
    fill(0, 255, 0, 128);
    ellipse(x1, y1, 10, 10);
    ellipseMode(CENTER);
    noStroke();
    fill(255, 0, 0, 128);
    ellipse(x2, y2, 10, 10);
  } else if (count == 4) {
    if (sol != null && i<sol.size()) {
      Node n = sol.get(i);
      set(n.getX(), n.getY(), color(0, 0, 255));
      fill(0, 0, 255, 128);
      ellipse(n.getX(), n.getY(), 5, 5);
      i++;
    }
  }
}

void mousePressed() {
  if (count == 0) {
    saveFrame ("test.png");
//    currentImage = "test-" + picNum + ".png";
    count++;
  } else if (count == 1) {
    x1 = mouseX;
    y1 = mouseY;
    count++;
  } else if (count == 2) {
    x2 = mouseX;
    y2 = mouseY;
    count++;
  } else if (count == 3) {
    int start = millis();
    MazeSolver something = new MazeSolver (board, /*1, 1, board.length - 2, board[0].length - 2*/x1, y1, x2, y2);
    sol = something.solve();
    count++;
    int step = millis();
    println (step - start + "ms");
  } else {
    i = 0;
    count = 0;
  }
}

void drawEdges() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (x == 0 || x == width - 1 || y == 0 || y == width - 1) 
        edges.set(x, y, fg);
      else 
        checkEdges(x, y);
    }
  }
}

void checkEdges(int x, int y) {
  int horizontal = 0, vertical = 0;
  float value;
  int c = averageVal(x, y);
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      horizontal += abs(averageVal(x + i, y + j) - c) * kernelLR[i + 1][j + 1];
      vertical += abs(averageVal(x + i, y + j) - c) * kernelUD[i + 1][j + 1];
    }
  }
  value = sqrt(sq(horizontal) + sq(vertical));
  if (value > threshold) 
    edges.set(x, y, fg);
  else 
    edges.set(x, y, bg);
}

int averageVal(int x, int y) {
  color c = img.get(x, y);
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  float value = (r + g + b) / 3;
  if (value > pivot) 
    value += (255 - value) * contrastAdj;
  else
    value -= value * contrastAdj;
  return (int)value;
}

void keyPressed() {
  if (key == 'e') 
    edge = !edge;
  if (key == 'b');
  blob = !blob;
  if (key == 'a') 
    pivot -= 1;
  if (key == 'd')
    pivot += 1;
  if (keyCode == UP)
    contrastAdj += 0.01;
  if (keyCode == DOWN) 
    contrastAdj -= 0.01;
  if (keyCode == LEFT)
    threshold -= 1;
  if (keyCode == RIGHT)
    threshold += 1; 
  checkAdj();
}

void checkAdj() {
  if (pivot > 255) 
    pivot =  255;
  if (pivot < 0) 
    pivot = 0;
  if (threshold < 0)
    threshold = 0;
  if (contrastAdj < 0)
    contrastAdj = 0;
  if (contrastAdj > 1)
    contrastAdj = 1;
}

void blobDetect() {
  int count = 1;
  for (int x = 1; x < width - 1; x++) {
    for (int y = 1; y < height - 1; y++) {
      if (edges.get(x, y) == bg) {
        int a = buffer[x - 1][y - 1];
        int b = buffer[x][y - 1];
        int c = buffer[x + 1][y - 1];
        int d = buffer[x - 1][y];
        if (a == 0 && b == 0 && c == 0 && d == 0) {
          buffer[x][y] = count;
          count++;
        } else {
          int min = findMin(a, b, c, d);
          buffer[x][y] = min;
          if (edges.get(x - 1, y - 1) == fg) 
            buffer[x - 1][y - 1] = min;
          if (edges.get(x, y - 1) == fg) 
            buffer[x][y - 1] = min;
          if (edges.get(x + 1, y - 1) == fg) 
            buffer[x + 1][y - 1] = min;
          if (edges.get(x - 1, y) == fg) 
            buffer[x - 1][y ] = min;
        }
      }
    }
  }
  blobFill(count);
}

int findMin(int a, int b, int c, int d) {
  int[] arr = {
    a, b, c, d
  };
  int min = max(arr);
  if (a < min && a != 0)
    min = a;
  if (b < min && b != 0)
    min = b;
  if (c < min && c != 0)
    min = c;
  if (d < min && d != 0)
    min = d;  
  return min;
}

void blobFill(int c) {
  float fill = 255 / c;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int label = buffer[x][y];
      color co = color(fill * label, 0, 0);
      blobs.set(x, y, co);
    }
  }
}

void fillBoard() {
  for (int x = 0; x < height; x++) {
    for (int y = 0; y < width; y++) {
      if (edges.get(x, y) == fg) 
        board[y][x] = 1;
      else 
        board[y][x] = 0;
      if (x == 0 || x == height - 1 || y == 0 || y == width - 1) 
        board[y][x] = 1;
    }
  }
}
