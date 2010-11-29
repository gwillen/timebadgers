import World;
import Jump;
import flash.display.Sprite;
import flash.display.Bitmap;

typedef StepResult = {
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

  public static function get(w : World_t, x : Int, y : Int) : Tile {
    if (x < 0 || x >= World.tilesw || y < 0 || y > World.tilesh) {
      return World.allTiles[World.WALL];
    }
    return w[y * World.tilesw + x];
  }

  public static function set(w : World_t, x : Int, y : Int, t : Tile) {
    // XXX no bounds checks!
    if (x < 0 || x >= World.tilesw || y < 0 || y > World.tilesh) {
      trace('OOB ASSHOLE');
    } else {
      w[y * World.tilesw + x] = t;
    }
  }

  // If you are stepped on, then you are dead.
  public static function steppedOn(w : World_t, x : Int, y : Int) {
    var t = get(w, x, y - 1);
    return t.style.prop.isbadger || t.style.prop.isturtle;
  }

 // Compute the next world state from the current one.
 public static function step(w : World_t) : World_t {
   // XXX should be same size as w; allegedly this allocates
   // as fields are accessed.
   var newworld = new Array<Tile>();
   // trace('make step!');
   for (y in 0...World.tilesh) {
     for (x in 0...World.tilesw) {
       newworld.push(World.allTiles[World.NOTHING]);
     }
   }
   
   for (y in 0...World.tilesh) {
     for (x in 0...World.tilesw) {
       var thistile = get(w, x, y);
       if (thistile == null) {
	 trace('null ASSHOLE2');
       }

       switch (thistile.style.id) {
       case 0x0000: // NOTHING
	 // Don't do anything, because we don't want to overwrite
	 // new material that moved into this spot.
	 
       case 0x000a: // MOVEDOWN
	 if (get(w, x, y + 1).style.prop.solid) {
	   // Blocked; flip in place.
	   set(newworld, x, y, World.allTiles[World.MOVEUP]);
	 } else {
	   set(newworld, x, y + 1, thistile);
	   set(newworld, x, y, World.allTiles[World.NOTHING]);
	 }

       case 0x000b: // MOVELEFT
	 if (get(w, x - 1, y).style.prop.solid ||
	     // because this is lexicographically before
	     get(newworld, x - 1, y).style.prop.solid) {
	   // Blocked; flip in place.
	   set(newworld, x, y, World.allTiles[World.MOVERIGHT]);
	 } else {
	   set(newworld, x - 1, y, thistile);
	   set(newworld, x, y, World.allTiles[World.NOTHING]);
	 }

       case 0x000c: // MOVERIGHT
	 if (get(w, x + 1, y).style.prop.solid) {
	   // Blocked; flip in place.
	   set(newworld, x, y, World.allTiles[World.MOVELEFT]);
	 } else {
	   set(newworld, x + 1, y, thistile);
	   set(newworld, x, y, World.allTiles[World.NOTHING]);
	 }

       case 0x000d: // MOVEUP
	 if (get(w, x, y - 1).style.prop.solid ||
	     // because this is lexicographically before
	     get(newworld, x, y - 1).style.prop.solid) {
	   // Blocked; flip in place.
	   set(newworld, x, y, World.allTiles[World.MOVEDOWN]);
	 } else {
	   set(newworld, x, y - 1, thistile);
	   set(newworld, x, y, World.allTiles[World.NOTHING]);
	 }

       case 0x0001: // TURTLE L
	 var xx : Int, yy : Int, deadtile : Int;
         if (get(w, x - 1, y).style.prop.isbadger ||
	     (!get(w, x - 1, y).style.prop.solid &&
              !get(newworld, x - 1, y).style.prop.solid)) {
	   // Might kill badger!
	   var noth = World.allTiles[World.NOTHING];
	   set(newworld, x - 1, y, thistile);
	   set(newworld, x, y, noth);
	   xx = x - 1;
	   yy = y;
	   deadtile = World.TURTLELDEAD;
	 } else {
	   // Flip in place.
	   set(newworld, x, y, World.allTiles[World.TURTLER]);
	   xx = x;
	   yy = y;
	   deadtile = World.TURTLERDEAD;
	 }

	 if (steppedOn(w, xx, yy)) {
	   set(newworld, xx, yy, World.allTiles[deadtile]);
	 }

       case 0x0002: // TURTLE R
	 var xx : Int, yy : Int, deadtile : Int;
         if (get(w, x + 1, y).style.prop.isbadger ||
	     !get(w, x + 1, y).style.prop.solid) {
	   // Might kill badger!
	   set(newworld, x + 1, y, thistile);
	   set(newworld, x, y, World.allTiles[World.NOTHING]);
	   xx = x + 1;
	   yy = y;
	   deadtile = World.TURTLERDEAD;
	 } else {
	   // Flip in place.
	   set(newworld, x, y, World.allTiles[World.TURTLEL]);
	   xx = x;
	   yy = y;
	   deadtile = World.TURTLELDEAD;
	 }

	 if (steppedOn(w, xx, yy)) {
	   set(newworld, xx, yy, World.allTiles[deadtile]);
	 }

       case 0x0035: // Dead turtles
	 set(newworld, x, y, World.allTiles[World.NOTHING]);
       case 0x0036: // Dead turtles
	 set(newworld, x, y, World.allTiles[World.NOTHING]);

       default:
	 set(newworld, x, y, thistile);
       }
     }
   }

   trace('return: ' + newworld.length);
  return newworld;
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
   var newmvs = Utils.map(function(c) {
                      return {x : c.x + player_x, y : c.y + player_y};
                     },
                     mvs);
   drawMoves(newmvs);                    
 }


}
