import java.util.*;

class MazeSolver {
  int[][] maze;
  Node[][] nodes;
  int startX, startY;
  int endX, endY;
  int traveled = 0;
  PriorityQueue<Node> openSet = new PriorityQueue<Node>(); //this is the open list aka THE FRINGE
  //ArrayList<Node> open = new ArrayList<Node>();
  ArrayList<Node> closedSet = new ArrayList<Node>();
  
  
  public MazeSolver(int[][] m, int sx, int sy, int ex, int ey) {
    maze=m;
    startX=sx;
    startY=sy;
    endX=ex;
    endY=ey;
    setupNodes();
    fringe.add(nodes[startY][startX]);
    solve();
  }

  void setupNodes() {
    for (int r=0; r<maze.length; r++) {
      for (int c=0; c<maze[0].length; c++) {
        if (maze[r][c]==0) {
          nodes[r][c] = new Node(c, r);
        }
      }
    }
  }

  void solve() {
 
    Node start = new Node(startX,startY); //starting node 
    openSet.add(start); //add starting node to openSet 
    boolean done = false;
    Node current; 
    
    while (!(done)) { 
      current = //get node with lowest fCost from openlist
      closedSet.add(current);
      openSet.remove(current);
      
    }
  }
  
  Node lowestFInOpen() { //returns Node with lowest fCost in openSet
  }
  
    /////////////better pseudocode
    /*
    create the open list of nodes, initially containing only our starting node
     create the closed list of nodes, initially empty
     while (we have not reached our goal) {
     consider the best node in the open list (the node with the lowest f value)
     if (this node is the goal) {
     then we're done
     }
     else {
     move the current node to the closed list and consider all of its neighbors
     for (each neighbor) {
     if (this neighbor is in the closed list and our current g value is lower) {
     update the neighbor with the new, lower, g value 
     change the neighbor's parent to our current node
     }
     else if (this neighbor is in the open list and our current g value is lower) {
     update the neighbor with the new, lower, g value 
     change the neighbor's parent to our current node
     }
     else this neighbor is not in either the open or closed list {
     add the neighbor to the open list and set its g value
    */
    
    
     /////////////////////////////
    /*while there is something in the fringe
     remove the next node
     add all unvisited neighbors to the frontier
     mark them as visited
     and remove that node
     continue this until we find the end
     to recover path once we are at end, give each node a list of nodes
     when a node is added to frontier, the added node is appened to that nodes list/
     */

    Node n = fringe.poll();
  }

  float h(Node n) {
    float ahead = dist(n.getX(), n.getY(), endX, endY); //distance between node and end
    return ahead+traveled;
  }
}

