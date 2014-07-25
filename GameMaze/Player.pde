class Player {

  int x, y;
  int d;
  int i;
  boolean willMoveObstacle;

  public Player(int x, int y, int d) {
    this.x = x;
    this.y = y;
    this.d = d;
    i = 0;
    willMoveObstacle = false;
  }

  void draw() {
    fill(255, 255, 0);
    noStroke();
    ellipse(x, y, 10, 10);
  }

  void move (int[][] board, int endX, int endY) {
    MazeSolver ms = new MazeSolver (board, x, y, endX, endY);
    ArrayList<Node> path = ms.solve();
    if (i < path.size() && i < d) {
      if (path.size() > 1 ) {
        Node n = path.get(1);
        x = n.getX();
        y = n.getY();
        i ++;
      }
    } 
    //this doesnt work in current context of code
    else {
      i = 0;
    }
  }
}

