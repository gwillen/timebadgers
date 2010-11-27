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

overtwo = jmp (2,0) [(1,0)]
overthree = jmp (3,0) [(1,0), (2,0)]


*/

  static var upone : Jmp = { dest : {x:0, y:-1}, path : []  } ;
  static var uptwo : Jmp = { dest : {x:0, y:-2}, path : [ {x:0,y:-1}]  } ;
  static var upthree : Jmp = { dest : {x:0, y:-3}, path : [{x:0,y:-1},{x:0,y:-2}] } ;

  static var arr: Array<Int>  = [1,2,3,4,5,6];


  static function main() {


    trace ("Hello world!" + arr + "   " + upone);
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