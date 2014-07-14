class Node implements Comparable{
 
  int x, y;
  float h;
  float traveled=Integer.MAX_VALUE;
  Node parent;
  boolean visited = false;


  public Node(int x, int y){
    parent = null;
    this.x=x;
    this.y=y;
  }
  public Node(int x, int y, float h){
    this.x=x;
    this.y=y;
    this.h=h;
  }
  
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  float getH(){
    return h;
  }
  float getTraveled(){
    return traveled;
  }
  void setTraveled(float t){
    traveled=t;
  }
  void setH(float newh){
    h = newh;
  }
  Node getParent(){
    return parent;
  }
  void setParent(Node n){
    parent = n;
  }
  
  //Node are compared based on the heuristic value
  int compareTo(Object o){
    if(o instanceof Node){
      Node n = (Node)o;
      float diff = h-n.getH();
      if(diff>0){
        return 1;
      }
      else if(diff<0){
        return -1;
      }else{
        return 0;
      }
    }
    else{
      return 0;
    }
  }
  
  boolean isVisited(){
    return visited;
  }
  void setVisited(boolean v){
    visited = v;
  }
  
  String toString() {
    return "{" + x + "," + y + "}";
  }
}
