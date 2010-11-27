class World {}

enum TileType {
  nothing;
  floor;
  movingfloor;
  floorstop;  // Displays and acts like nothing, but stops moving floors
  butan;  // Pressed or unpressed
  man;
  turtal;
}

class MovingFloor {
  //var id:int;  // id of linked butan
}

class Tile {
  public static var size:Int = 20; // width and height
  public var image:flash.display.Loader;
  var type:TileType;

  public function new() {}
}

