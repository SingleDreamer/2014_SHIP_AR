import java.io.*;
import java.util.*;

class Computer {
  
   int x, y;
   int radius;
   
   public Computer(int x, int y, int r) {
     this.x = x;
     this.y = y;
     radius = r;
   }
   
   void move (int[] board, endX, endY) {
     Mazesolver ms = new Mazesolver (board, x, y, endX, endY);
     
   }
   
}
