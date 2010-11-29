import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;

import World;




typedef Jmp = {
    var dest : Coor;
    var path : Array<Coor>;
} 


class Jump extends Sprite {

  // read a jump from an array of coors. First coor is dest, rest are path.
  static function readjmp(a : Array<Coor>) : Jmp {
    if(a.length < 1 )
      { // bad input
        return {dest : {x:0,y:0}, path : []};
      }
    var d: Coor = a[0];
    return {dest : d, path : a.slice(1)};
  }

  static var u : Jmp = { dest : {x:0, y:-1}, path : []  } ;
  static var uu : Jmp = { dest : {x:0, y:-2}, path : [ {x:0,y:-1}]  } ;
  static var uuu : Jmp = { dest : {x:0, y:-3}, path : [{x:0,y:-1},{x:0,y:-2}] } ;

  static var ru : Jmp = { dest: {x:1,y:-1}, path : [{x:0,y:-1}]};
  static var ruu  : Jmp = { dest : {x:1,y:-2}, path : [{x:0,y:-1}, {x:0,y:-2}]};
  static var ruuu : Jmp = readjmp( [ {x:1,y:-3},{x:0,y:-1}, {x:0,y:-2}, {x:0,y:-3}]); 
  static var rr  = readjmp([ {x:2,y:0}, {x:1,y:0}]);
  static var rru  = readjmp([ {x:2,y:-1}, {x:1,y:-1}]);
  static var rruu  = readjmp([ {x:2,y:-2}, {x:0,y:-1}, {x:1,y:-2}]);
  static var rrr  = readjmp([ {x:3,y:0}, {x:1,y:0}, {x:2,y:0}]);
  static var rrru  = readjmp([ {x:3,y:0}, {x:1,y:-1}, {x:2,y:-1}]);

  static var rd = readjmp([{x:1,y:1},{x:1,y:0}]);
  static var rdd = readjmp([{x:1,y:2},
                            {x:1,y:0},
                            {x:1,y:1}]);
  static var rddd = readjmp([{x:1,y:3},
                             {x:1,y:0},
                             {x:1,y:1},
                             {x:1,y:2}]);
  static var rdddd = readjmp([{x:1,y:4},{x:1,y:0},{x:1,y:1},{x:1,y:2},{x:1,y:3}]);

  static var rrd = readjmp([{x:2,y:1},
                            {x:1,y:0}]);
  static var rrdd = readjmp([{x:2,y:2},
                             {x:1,y:0},
                             {x:2,y:1}]);
  static var rrddd = readjmp([{x:2,y:3},
                              {x:1,y:0},
                              {x:2,y:1},
                              {x:2,y:2}]);

  static var rrrd = readjmp([{x:3,y:1},
                             {x:1,y:0},
                             {x:2,y:0}]);

  static var rrrdd = readjmp([{x:3,y:2},
                              {x:1,y:0},
                              {x:2,y:0},
                              {x:3,y:1}]);
                             

  static function reflectcoor(c : Coor): Coor {
         return {x: -c.x, y: c.y};
  }

  static function reflectjmp(j : Jmp): Jmp {
   var d = reflectcoor(j.dest);
   var p = j.path.copy();
   for(i in 0...p.length){
         p[i] = reflectcoor(j.path[i]);
   }
   return {dest : d, path : p};
  } 

  static function arrmap<T>(a : Array<T>, f : T -> T) : Array<T> {
   var a1 =  a.copy();
   for( i in 0...a.length){
      a1[i] = f(a[i]);
   }
   return a1;
 }


  static var rightjmps:Array<Jmp> = [ru,ruu,ruuu,rr,rru,rruu,rrr,rrru,
                                     rd,rdd,rddd,rdddd,rrd,rrdd,rrddd,rrrd,rrrdd];

  static var leftjmps:Array<Jmp> = arrmap(rightjmps, reflectjmp);
                       

  public static var jmps = rightjmps.concat(leftjmps).concat([u,uu,uuu]);


  static function stringofcoor(c : Coor){
    return  ("(" + c.x + "," + c.y  + ")");
  } 

  static function stringofjmp(j : Jmp) {
    var d =  ( "dest= " + stringofcoor(j.dest) + " path = ");
    for( i in 0...j.path.length) {
         d = d + (stringofcoor(j.path[i])  );
    }
    return d;
  } 




  public static function canJump(j:Jmp, w0: World_t, w1: World_t, x: Int, y: Int): Bool {
       var r: Bool = true;
        if(! World.canStandOn(w1, j.dest.x + x, j.dest.y + y)){
             r = false;
        }

        for(p in j.path){
           if(World.isBlocked(w0, p.x + x, p.y + y)){
                r = false;
           }
        }

        return r;
  }

  public static function validJumps(w0: World_t, w1: World_t, x: Int, y: Int)
  : Array<Jmp> {
    return Utils.filter(function (j) { return canJump(j, w0, w1, x, y); }, jmps);
  }



  static function main() {
    trace ( stringofjmp(leftjmps[6] ));

    trace ("Hello world!" + jmps[0] + "   " + "length=" + jmps.length );
    var mc:flash.display.MovieClip = flash.Lib.current;
    // type annotation not necessary
    mc.graphics.beginFill(0xFF0000);
    mc.graphics.moveTo(50,50);
    mc.graphics.lineTo(100,50);
    mc.graphics.lineTo(100,100);
    mc.graphics.lineTo(50,100);
    mc.graphics.endFill();


  }
}
