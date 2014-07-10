class Node implements Comparable{
 
  int x, y, h;
  ArrayList<Node> path;


  public Node(int x, int y){
    path = new ArrayList<Node>();
    this.x=x;
    this.y=y;
  }  
  public Node(int x, int y, int h){
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
  int getH(){
    return h;
  }
  ArrayList<Node> getPath(){
    return path;
  }
  void addToPath(Node n){
    path.add(n);
  }
  
  int compareTo(Object o){
    if(o instanceof Node){
      Node n = (Node)o;
      return h-n.getH();
    }
    else{
      return 0;
    }
  }
  
  String toString() { 
    return "{" + x + "," + y + "}";
  }
}
