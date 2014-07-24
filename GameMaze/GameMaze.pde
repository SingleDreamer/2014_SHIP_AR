//make it so can update picture
//add realtime search color 
//arrayindexoutofboundsexception???


import processing.video.*;
Capture cam;

int currentPlayer=-1; //0: PL; 1: CP (nobodys turn in the beginning)
Player PL;
Computer CP;
boolean endTurn;
int endTurnCounter=60;
int ENDTURNCOUNTERMAX = 60;

PImage img, edges, blobs, current;
color bg = color(255);
color fg = color(200);
int threshold = 50;
float contrastAdj = 0.4;
int pivot = 255 / 2;
int count, x1, y1, x2, y2, goalX, goalY, plX, plY;
float r2 = sqrt(2);
ArrayList<Node> sol;
int i;
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
boolean edge, blob, moving;

String currentImage;
//int picNum;

void setup() {
  //  picNum = 1;

  //size (640, 480); FIX THIS AT SOME POINT
  size(500, 500);
  i = 0;
  count = 0;
  edges = createImage(width, height, RGB);
  blobs = createImage(width, height, RGB);
  buffer = new int[width][height];
  board = new int[width][height];

  moving = false;

  String[] cameras = Capture.list();

  if (cameras.length == 0) {

    exit();
  } else {
    cam = new Capture(this, cameras[1]);
    cam.start();
  }
  
}

void findPL(){
  
//  int bx1=-1;
//  int by1=-1;
//  int bx2=-1;
//  int by2=-1;
  
  int sumX=0;
  int sumY=0;
  int numP=0;
  
  int bxa, bya;
  loadPixels();
  println(pixels.length);
  for(int k=0; k<pixels.length; k++){
    color c = pixels[k];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    if(r>=70 && r<=100 && g>=120 && g<=190 && b>=170){
      println("found blue");
      sumX+=k % width;
      sumY+=k / width;
      numP++;
//      if(bx1==-1){
//        bx1=k % width;
//        by1=k / width;
//      }
//      else{
//        bx2=k % width;
//        by2=k / width;
//      }
    } 
//    bxa = (bx1+bx2)/2;
//    bya = (by1+by2)/2;
    //count++;
  }
  if(numP!=0){
    bxa = sumX / numP;
    bya = sumY / numP;
    x2 = bxa;
    y2 = bya;
  }
}

void findEndTurn(){
  if(endTurnCounter>0){
    endTurn = false;
    endTurnCounter--;
    return;
  }
  endTurnCounter = ENDTURNCOUNTERMAX;
  //  int bx1=-1;
//  int by1=-1;
//  int bx2=-1;
//  int by2=-1;
  
  int sumX=0;
  int sumY=0;
  int numP=0;
  
  int bxa, bya;
  loadPixels();
  println(pixels.length);
  for(int k=0; k<pixels.length; k++){
    color c = pixels[k];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    if(r>=140 && r<=180 && g>=0 && g<=70 && b>=130 && b<=180){
      println("found pink");
      sumX+=k % width;
      sumY+=k / width;
      numP++;
//      if(bx1==-1){
//        bx1=k % width;
//        by1=k / width;
//      }
//      else{
//        bx2=k % width;
//        by2=k / width;
//      }
    } 
//    bxa = (bx1+bx2)/2;
//    bya = (by1+by2)/2;
    //count++;
  }
//  bxa = sumX / numP;
//  bya = sumY / numP;
//  x2 = bxa;
//  y2 = bya;
  endTurn = (numP<3);
}

void findGoal(){
//  if(endTurnCounter>0){
//    endTurn = false;
//    endTurnCounter--;
//    return;
//  }
//  endTurnCounter = ENDTURNCOUNTERMAX;
  //  int bx1=-1;
//  int by1=-1;
//  int bx2=-1;
//  int by2=-1;
  
  int sumX=0;
  int sumY=0;
  int numP=0;
  
  int bxa=0;
  int bya=0;
  loadPixels();
  println(pixels.length);
  for(int k=0; k<pixels.length; k++){
    color c = pixels[k];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    if(r>=27 && r<=52 && g>=68 && g<=84 && b>=53 && b<=87){
      println("found green");
      sumX+=k % width;
      sumY+=k / width;
      numP++;
//      if(bx1==-1){
//        bx1=k % width;
//        by1=k / width;
//      }
//      else{
//        bx2=k % width;
//        by2=k / width;
//      }
    } 
//    bxa = (bx1+bx2)/2;
//    bya = (by1+by2)/2;
    //count++;
  }
  if (numP != 0){
    bxa = sumX / numP;
    bya = sumY / numP;
  }
  goalX = bxa;
  goalY = bya;
//  endTurn = (numP<3);
}

void draw() {
  
  
  if (cam.available() == true) {
    cam.read();
  }
  
  image(cam, 0, 0);
  if (count == 0) {  
    //    if (cam.available() == true) {
    //      cam.read();
    //    }
    //    image(cam, 0, 0);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
  } else if (count == 1) {
    //    img = loadImage ("test.png");
    //    drawEdges();
    //    //image(edges, 0, 0);
    //    fillBoard();
    //cam.read();
    //    image(cam, 0, 0);
    if (CP == null) 
      CP = new Computer(x1, y1, 50);
    
      
    findPL();
//    findEndTurn();
    count++;
    
    drawEdges();
    fillBoard();
    CP.draw();
  } else if (count == 2) {
    //    drawEdges();
    //    //image(edges, 0, 0);
    //    fillBoard();
    //    ellipseMode(CENTER);
    //    noStroke();
    //    fill(0, 255, 0, 128);
    //    ellipse(x1, y1, 10, 10);
    //cam.read();
    //image(cam, 0, 0);
    CP.draw();
    if (PL == null)
      PL = new Player(x2, y2, 50);
    PL.draw();
  } else if (count == 3) {
    //cam.read();
    //image(cam, 0, 0);
    CP.draw();
    PL.draw();
    
    findGoal();
    count++;
    
    fill(255, 0, 0);
    rect(goalX - 5, goalY - 5, 10, 10);
  } 
  else if (endgame()) {
    currentPlayer = -1; 
  } 
  else if (currentPlayer == 1) {
    //    if (sol != null && i<sol.size()) {
    //      Node n = sol.get(i);
    //      set(n.getX(), n.getY(), color(0, 0, 255));
    //      fill(0, 0, 255, 128);
    //      ellipse(n.getX(), n.getY(), 5, 5);
    //      i++;
    //    }
    PL.draw();
    fill(255, 0, 0);
    rect(goalX - 5, goalY - 5, 10, 10);

    if (CP.i != CP.d) {
      CP.move(board, goalX, goalY);
    } else {
      CP.i = 0;
      currentPlayer = 0;
      println ("need to clicky");
    }
    CP.draw();
  } else if (currentPlayer == 0) {
    CP.draw();
    fill(255, 0, 0);
    rect(goalX - 5, goalY - 5, 10, 10);
    
    findEndTurn();
    if (!PL.willMoveObstacle && endTurn) {
      findPL();
      if (dist(PL.x, PL.y, x2, y2) <= 100) {
        moving = true;
        plX = x2;
        plY = y2;
      }
    }
    
    if (!PL.willMoveObstacle) {
      if (moving) {
        if (PL.i < PL.d && dist(PL.x, PL.y, plX, plY) != 0) {
          PL.move (board, plX, plY);
        } else {
          print("switch player");
          PL.i = 0;
          currentPlayer = 1;
          moving = false;
        }
      } else {
        noStroke();
        fill (0, 255, 0, 50);
        ellipse (PL.x, PL.y, 100, 100);
      }
    } else {
      //recapture photo from camera
      //end of turn
      drawEdges();
      fillBoard();
      currentPlayer = 1;
      PL.willMoveObstacle = false;
    }

    PL.draw();
  }

  //println (currentPlayer);
}

void mousePressed() {
  color c = get(mouseX,mouseY);
  println("clicked: ("+red(c)+","+green(c)+","+blue(c)+")");
  
  if (count == 0) {
    x1 = mouseX;
    y1 = mouseY;
    count++;
    
  } /*else if (count == 1) {
    x2 = mouseX;
    y2 = mouseY;
    count++;
  } else if (count == 2) {
    goalX = mouseX;
    goalY = mouseY;
    count++;
  } */else if (count == 3) { 
    currentPlayer = 1;
    count++;
  } else if (currentPlayer == 0) {
//    if (!PL.willMoveObstacle) {
//      if (dist(PL.x, PL.y, mouseX, mouseY) <= 100) {
//        moving = true;
//        plX = mouseX;
//        plY = mouseY;
//      }
//    }
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

  color c = cam.get(x, y);
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
  if (key == 'm')
    PL.willMoveObstacle = true;
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


boolean endgame() {
  return ((CP.x >= goalX - 5 && CP.x <= goalX + 5) && (CP.y >= goalY - 5 && CP.y <= goalY + 5)) || ((PL.x >= goalX - 5 && PL.x <= goalX + 5) && (PL.y >= goalY - 5 && PL.y <= goalY + 5));
}
