typedef Coor = {
    var x : Int;
    var y : Int;
}   

typedef Jmp = {
    var dest : Coor;
    var path : Array<Coor>;
} 


class Jump {

/*

upone = jmp (0, -1) []
uptwo = jmp (0,-2) [(0,-1)]
upthree = jmp (0,-3) [(0,-1), (0,-2)]


rightupone = jmp (1,-1) [(0,-1)]
rightuptwo  = jmp (1,-2) [(0,-1), (0,-2)]
rightupthree = jmp (1,-3) [(0,-1), (0,-2), (0,-3)]




*/

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
                             

  static var arr: Array<Int>  = [1,2,3,4,5,6];

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



  static function main() {
//    trace ( stringofjmp(rightupthree ));

    trace ("Hello world!" + arr[0] + "   " + "length=" + arr.length );
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