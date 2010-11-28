import World;
import Jump;

class Simulate {

 /* 
   btw: 
  theme from time badger 
 2x   Gm C Gm D7
  
 2x  Bm7 Em Bm7 Amaj 9
 */


 static function validjumps(w0: World_t, w1: World_t, x: Int, y: Int) : Array< Coor>{
    var r: Array<Coor>  = new Array<Coor>();
     for(j in Jump.jmps){
           if(Jump.canJump(j, w0, w1, x,y)){
               r.push({x:x, y:y});
         }
     }
   return r;
 }

}