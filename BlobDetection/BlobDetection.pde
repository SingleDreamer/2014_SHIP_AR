//make it so can update picture
//for some reason 2d array is turned counterclockwise
//add realtime search color 

PImage img, edges, blobs, path, current;
color bg = color(255);
color fg = color(200);
int threshold = 50;
float contrastAdj = 0.4;
int pivot = 255 / 2;
int count, x1, y1, x2, y2;
boolean solved;
float r2 = sqrt(2);
ArrayList<Node> sol;
int i = 0;
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
//path does not show up on maze3?????
void setup() {
  img = loadImage("maze3.png");
  size(img.width, img.height);
  edges = createImage(width, height, RGB);
  blobs = createImage(width, height, RGB);
  path = createImage(width, height, RGB);
  buffer = new int[width][height];
  board = new int[width][height];

  count = 0;
  solved = false;

  drawEdges();
  //blobDetect();
  image(edges, 0, 0);
  ///image(blobs, 0, 0);
  fillBoard();
}

void draw() {
  //  drawEdges();
  //  //blobDetect();
  //  image(edges, 0, 0);
  //  ///image(blobs, 0, 0);
  //  fillBoard();
  //print ("(" + mouseX + ", " + mouseY + ")" + " (" + x1 + ", " + y1 + ") " + "(" + x2 + ", " + y2 + " )" + "\n");
//  print (board[mouseX][mouseY]);

  if(sol != null && i<sol.size()){
    Node n = sol.get(i);
    set(n.getX(),n.getY(),color(0,0,255));
    i++;
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
    }
  }
  for (int x = 0; x < width; x++) {
  for (int y = 0; y < height; y++) {
  print(board[x][y]);
  }
  println();
  }
}

void mousePressed() {
  /*for (int x = 0; x < width; x++) {
   for (int y = 0; y < height; y++) {
   print(board[x][y]);
   }
   println();*/
  //}
  if (count == 0) {
    x1 = mouseX;
    y1 = mouseY;
    ellipseMode(CENTER);
    noStroke();
    fill(0,255,0,128);
    ellipse(x1,y1,10,10);
    count ++;
  } else if (count == 1) {
    x2 = mouseX;
    y2 = mouseY;
    ellipseMode(CENTER);
    noStroke();
    fill(255,0,0,128);
    ellipse(x2,y2,10,10);
    count++;
  } else if (count == 2) {
    int start = millis();
    MazeSolver something = new MazeSolver (board, /*1, 1, board.length - 2, board[0].length - 2*/x1, y1, x2, y2);
    sol = something.brianSolve();
    /*
    translate (something.getMaze());
    image (path, 0, 0);
//    image (edges, 0, 0);
*/
    ellipseMode(CENTER);
    noStroke();
    fill(0,255,0,128);
    ellipse(x1,y1,10,10);
    fill(255,0,0,128);
    ellipse(x2,y2,10,10);
    count++;
    int step = millis();
    println (start - step + "ms");
  }
  else {
    println ("no more actions bozo");
  }
}


void translate (int[][] p) {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (p [i][j] == 0) {
        path.set(j, i, bg);
      } else if (p [i][j] == 1) {
        path.set(j, i, fg);
      } else if (p [i][j] == -1) {
        path.set(j, i, color(255, 0, 0));
      } else {
        path.set(j, i, color(0, 255, 0));
      }
//      if (p [i][j] == -1) {
//        edges.set(j, i, color(255, 0, 0));
//      }
//      else {
//        path.set(j, i, color (0,0,0,0));
//      }
    }
  }
}
