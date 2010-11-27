import Utils.Option;
import Utils;
import flash.net.URLRequest;
import flash.display.Loader;

class World {
  public static var tile1;
  public static var tile2;
  public static function loadStuff() {
    tile1 = new Loader();
    tile1.load(new URLRequest("assets/tile_dummy1.jpg"));
    tile2 = new Loader();
    tile2.load(new URLRequest("assets/tile_dummy2.jpg"));
  }
  var worldState: Array<Array<Tile>>;

  static var tileSz = 20; // XXX

  function initDrawWorld() {
    var x = 0;
    var y = 0;
    for (row in worldState) {
      for (tile in row) {
        var s = new Sprite();
        s.content = tile.getImage();
        s.x = x;
        s.y = y;
        Lib.current.addChild(s);
        x += tileSz;
      }
      x = 0;
      y += tileSz;
    }
  }
}

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
  var id:Option<Int>;  // id of linked butan
}

class Tile {
  public static var size:Int = 20; // width and height
  public var image:flash.display.Loader;
  var type:TileType;
  public function new() {}
  function getImage() {
    if (Math.random() > 0.5) {
      return World.tile1.content;
    } else {
      return World.tile2.content;
    }
  }
}

