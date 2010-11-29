import World;
import Jump;
import flash.display.Sprite;
import flash.display.Bitmap;

typedef StepResult {
  var world: World_t;
  var badger_died: Bool;
  var badger_on_floor: Bool;
}

class Simulate {

 /* 
   btw: 
  theme from time badger 
 2x   Gm C Gm D7
  
 2x  Bm7 Em Bm7 Amaj 9
 */

 // Compute the next world state from the current one.
 public static function step(w : World_t) : World_t {
   // var newworld = 
 }


 /* where can we jump if we start at {x,y} ?
  */
 public static function validJumps(w0: World_t, w1: World_t, x: Int, y: Int) : Array< Coor>{
    var r: Array<Coor>  = new Array<Coor>();
     for(j in Jump.jmps){
           if(Jump.canJump(j, w0, w1, x,y)){
               r.push({x:x, y:y});
         }
     }
   return r;
 }



 static function drawMove(mv: Coor){
        var s = new Sprite();
        s.x = mv.x * World.tilesize + World.tilesize / 2;
        s.y = mv.y * World.tilesize + World.tilesize / 2; // 12-pixel overlap zone
        s.graphics.beginFill(0x0000FF);
        s.graphics.drawCircle(0,0,7);
        s.graphics.endFill();
        s.visible= true;
        Game.mainmc.addChild(s);    
 }

 public static function drawMoves(mvs: Array<Coor>) {
   for(mv in mvs){
     drawMove(mv);
   }
 }

  // Draw an array of moves |mvs| which are relative to the player's position |x,y|.
 public static function drawMovesRel(player_x:Int, player_y:Int, mvs:Array<Coor>) {
   // XXX +?
   var newmvs = Utils.map(function(c) {
                      return {x : c.x + player_x, y : c.y + player_y};
                     },
                     mvs);
   drawMoves(newmvs);                    
 }


}
