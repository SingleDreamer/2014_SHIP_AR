import java.io.*;
import java.util.*;

class Computer {

  int x, y;
  int d;
  int i;


  public Computer(int x, int y, int d) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.d = 20;
    i = 0;
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
      }//this needs to be a thing
    } else {
      i = 0;
    }
  }


  //    for (int i=0; i<d; i++) {
  //      if (i<path.size()) {
  //        Node n = path.get(i);
  //        x=n.getX();
  //        y=n.getY();
  //      }
  //      else 
  //      break;
  //    }


  void draw() {
    fill(0, 0, 255);
    noStroke();
    ellipse(x, y, 10, 10);
  }
}

