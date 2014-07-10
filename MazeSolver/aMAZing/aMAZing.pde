void setup() {
  int[][] m = new int[4][5];
  m[0][0] = 1;
  m[1][2] = 1;
  m[1][3] = 1;
  m[2][0] = 1;
  m[3][0] = 1;
  m[3][2] = 1;
  m[3][4] = 1;

  String s="";
  for (int r=0; r<4; r++) {
    for (int c=0; c<5; c++) {
      s+=m[r][c]+"\t";
    }
    s+="\n";
  }
  println("before search");
  println(s);

  MazeSolver mz = new MazeSolver(m, 1, 0, 3, 3);
 
}
void draw() {
}

