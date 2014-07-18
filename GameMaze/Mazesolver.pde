import java.util.*;

class MazeSolver {

  int[][] maze;
  Node[][] nodes;
  int startX, startY;
  Node start, end;
  int endX, endY;
  PriorityQueue<Node> fringe = new PriorityQueue<Node>();

  public MazeSolver(int[][] m, int sx, int sy, int ex, int ey) {
    maze=m;
    startX=sx;
    startY=sy;
    endX=ex;
    endY=ey;
    setupNodes();
    fringe.add(nodes[startY][startX]); //at the start, the fringe only contains the start node
  }

  void setupNodes() {
    nodes = new Node[maze.length][maze[0].length];
    for (int r=0; r<maze.length; r++) {
      for (int c=0; c<maze[0].length; c++) {
        if (maze[r][c]==0) {
          //we can go here
          nodes[r][c] = new Node(c, r);
          if (c==startX && r==startY) {
            //we found the start
            start = nodes[r][c];
            start.setTraveled(0);
            start.setH(h(start));
          }
          if (c==endX && r==endY) {
            //we found the end
            end = nodes[r][c];
          }
        }
      }
    }
  }

  ArrayList<Node> solve() {
    //while there is something in the fringe
    while (fringe.size ()>0) {
      Node next = fringe.poll(); //get the best node in the fringe (based on heuristic)
      //keep removing from fringe until next has not already been removed
      while (next.isVisited ()) {
        next = fringe.poll();
      }
      next.setVisited(true); //make sure this node is not removed from the fringe ever again
//      println("next: "+next);
      if (next == end) {
        //we found the end!
        ArrayList<Node> path = getPath(next);
        return path;
      }

      //try to add all 8 neighbors to the fringe
      int r = next.getY();
      int c = next.getX();
      addNode(next, r-1, c-1);
      addNode(next, r-1, c);
      addNode(next, r-1, c+1);
      addNode(next, r, c-1);
      addNode(next, r, c+1);
      addNode(next, r+1, c-1);
      addNode(next, r+1, c);
      addNode(next, r+1, c+1);
    }

    //there is nothing left in the fringe and the end has not been found ==> there is no solution to the given maze
    println("empty fringe; no solution");
    PImage err = new PImage(maze[0].length,maze.length);
    for(int x=0; x<err.width; x++){
      for(int y=0; y<err.height; y++){
        color c = color(255);
        if(maze[y][x]==0){
          c=color(0);
        }
        err.set(x,y,c);
      }
    } 
    err.save(savePath("error.png"));
    return null;
  }

  void addNode(Node prev, int r, int c) {
    if (isLegal(r, c)) {
      Node next = nodes[r][c];
      //if the new traveled is a shorter path to next than its current travelled, then we should add it to the fringe
      float newTraveled = prev.getTraveled()+dist(prev.getX(), prev.getY(), c, r); 
      if (newTraveled < next.getTraveled()) {
        next.setParent(prev); //update the node's parent
        next.setTraveled(newTraveled); //update the node's distance traveled
        next.setH(h(next)); //update the node's heuristic
        fringe.add(next); //add the node to the fringe
      }
    }
  } 

  float h(Node n) {   
    //a node's heuristic is the sum of the distance it has traveled and the optimal distance to the end 
    float ahead = dist(n.getX(), n.getY(), endX, endY); //distance between node and end
    float traveled = n.getTraveled();
    return (ahead+traveled);
  }

  boolean isLegal(int r, int c) {
    //a node is legal if it is on the board, we can move there, and it has not already been removed from the fringe
    if (r>=0 && c>=0 && r<nodes.length && c<nodes[0].length) {
      return (nodes[r][c] != null) && (!nodes[r][c].isVisited());
    }
    return false;
  }

  void applySolution(ArrayList<Node> s) {
    //updates the maze to reflect the solution path
    for (Node n : s) {
      maze[n.getY()][n.getX()]=-1; // an element of the maze that is part of the path is marked with a -1
    }
  }
  
  int[][] getMaze() {
    return maze;
  }

  ArrayList<Node> getPath(Node n) {
    ArrayList<Node> path = new ArrayList<Node>();
    while (n != start) {
      path.add(n);
      n = n.getParent();
    }
    path.add(n);

    //reverse path so that it goes from start to end
    for (int i=0; i<path.size ()/2; i++) {
      Node tmp = path.get(path.size()-i-1);
      path.set(path.size()-i-1, path.get(i));
      path.set(i, tmp);
    }

    return path;
  }
}

