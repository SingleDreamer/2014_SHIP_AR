import java.util.*;

class MazeSolver {
  int[][] maze;
  Node[][] nodes;
  int startX, startY;
  Node start, end;
  int endX, endY;
  //int traveled = 0;
  PriorityQueue<Node> openSet = new PriorityQueue<Node>(); //this is the open list aka THE FRINGE
  //ArrayList<Node> open = new ArrayList<Node>();
  ArrayList<Node> closedSet = new ArrayList<Node>();

  PriorityQueue<Node> fringe = new PriorityQueue<Node>();//Brian is using this for testing 


  public MazeSolver(int[][] m, int sx, int sy, int ex, int ey) {
    maze=m;
    startX=sx;
    startY=sy;
    endX=ex;
    endY=ey;
    setupNodes();
    fringe.add(nodes[startY][startX]);
    ArrayList<Node> sol = brianSolve();
    println(sol.toString());
    //solve();
  }

  void setupNodes() {
    nodes = new Node[maze.length][maze[0].length];
    for (int r=0; r<maze.length; r++) {
      for (int c=0; c<maze[0].length; c++) {
        //println(nodes[r][c]);
        if (maze[r][c]==0) {
          nodes[r][c] = new Node(c, r);
          if (c==startX && r==startY) {
            start = nodes[r][c];
            start.setH(h(start));
          }
          if (c==endX && r==endY) {
            end = nodes[r][c];
          }
        }
      }
    }
  }

  ArrayList<Node> brianSolve() {
    while (fringe.size ()>0) {
      Node next = fringe.poll();
      println("next: "+next);
      //println("fringe: "+fringe.toString());
      if (next == end) {
        ArrayList<Node> path = next.getPath();
        path.add(end);
        return path;
      }
      int r = next.getY();
      int c = next.getX();
      Node tl, t, tr, l, ri, dl, d, dr;
      if (isLegal(r-1, c-1)) {
        tl = nodes[r-1][c-1];
        tl.addToPath(next);
        tl.setH(h(tl));
        tl.setVisited(true);
        fringe.add(tl);
      }
      if (isLegal(r-1, c)) {
        t = nodes[r-1][c];
        t.addToPath(next);
        t.setH(h(t));
        t.setVisited(true);
        fringe.add(t);
      }
      if (isLegal(r-1, c+1)) {
        tr = nodes[r-1][c+1];
        tr.addToPath(next);
        tr.setH(h(tr));
        tr.setVisited(true);
        fringe.add(tr);
      }
      if (isLegal(r, c-1)) {
        l = nodes[r][c-1];
        l.addToPath(next);
        l.setH(h(l));
        l.setVisited(true);
        fringe.add(l);
      }
      if (isLegal(r, c+1)) {
        ri = nodes[r][c+1];
        ri.addToPath(next);
        ri.setH(h(ri));
        ri.setVisited(true);
        fringe.add(ri);
      }
      if (isLegal(r+1, c-1)) {
        dl = nodes[r+1][c-1];
        dl.addToPath(next);
        dl.setH(h(dl));
        dl.setVisited(true);
        fringe.add(dl);
      }
      if (isLegal(r+1, c)) {
        d = nodes[r+1][c];
        d.addToPath(next);
        d.setH(h(d));
        d.setVisited(true);
        fringe.add(d);
      }
      if (isLegal(r+1, c+1)) {
        dr = nodes[r+1][c+1];
        dr.addToPath(next);
        dr.setH(h(dr));
        dr.setVisited(true);
        fringe.add(dr);
      }
    }
    return null;
  }

//  void solve() {
//
//    Node start = new Node(startX, startY); //starting node 
//    openSet.add(start); //add starting node to openSet 
//    boolean done = false;
//    Node current; 
//
//    while (! (done)) { 
//      current = //get node with lowest fCost from openlist
//      closedSet.add(current);
//      openSet.remove(current);
//    }
//  }
//
//
//
//  Node lowestFInOpen() { //returns Node with lowest fCost in openSet
//  }
//
//  /////////////better pseudocode
//  /*
//    create the open list of nodes, initially containing only our starting node
//   create the closed list of nodes, initially empty
//   while (we have not reached our goal) {
//   consider the best node in the open list (the node with the lowest f value)
//   if (this node is the goal) {
//   then we're done
//   }
//   else {
//   move the current node to the closed list and consider all of its neighbors
//   for (each neighbor) {
//   if (this neighbor is in the closed list and our current g value is lower) {
//   update the neighbor with the new, lower, g value 
//   change the neighbor's parent to our current node
//   }
//   else if (this neighbor is in the open list and our current g value is lower) {
//   update the neighbor with the new, lower, g value 
//   change the neighbor's parent to our current node
//   }
//   else this neighbor is not in either the open or closed list {
//   add the neighbor to the open list and set its g value
//   */
//
//
//  /////////////////////////////
//  /*while there is something in the fringe
//   remove the next node
//   add all unvisited neighbors to the frontier
//   mark them as visited
//   and remove that node
//   continue this until we find the end
//   to recover path once we are at end, give each node a list of nodes
//   when a node is added to frontier, the added node is appened to that nodes list/
//   */
//
//  //Node n = fringe.poll();
//  //}
  int h(Node n) {
    float ahead = dist(n.getX(), n.getY(), endX, endY); //distance between node and end
    float traveled = n.getPath().size();
    return (int)(ahead+traveled);
  }
  boolean isLegal(int r, int c) {
    if (r>=0 && c>=0 && r<nodes.length && c<nodes[0].length) {
      return (nodes[r][c] != null) && (!nodes[r][c].isVisited());
    }
    return false;
  }
}

