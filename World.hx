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
  static var size = 20; // width and height
  var type:TileType;
}

