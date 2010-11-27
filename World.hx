import Utils.Option;
import Utils;
import flash.Lib;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;

class World {
  public static var tile1:Loader;
  public static var tile2:Loader;
  public static var tile3:Loader;
  public static var tile4:Loader;
  public static var loaded:Int;
  public static function loadStuff() {
    tile1 = new Loader();
    tile1.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile1.load(new URLRequest("assets/tile_xwindows.png"));
    tile2 = new Loader();
    tile2.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile2.load(new URLRequest("assets/tile_suspensionbridge.png"));
    tile3 = new Loader();
    tile3.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile3.load(new URLRequest("assets/tile_zebra.png"));
    tile4 = new Loader();
    tile4.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile4.load(new URLRequest("assets/tile_psychedelic.png"));
    trace("World loading stuff.");
  }

  public static function completeHandler(event : Event) {
    var loader:Loader = event.target.loader;
    loaded++;

    if (loaded == 4) {
      // Now everything is loaded. This is stupid.
      trace("Going to init tiles.");
      Game.initTiles();
      trace("Going to draw tiles.");
      Game.drawTiles(Game.tiles);
      trace("Did draw tiles.");
    }
  }

  var worldState: Array<Array<Tile>>;

  static var tileSz = 20; // XXX

/*
  function initDrawWorld() {
    var x = 0;
    var y = 0;
    for (row in worldState) {
      for (tile in row) {
        var s = new Sprite();
        s.addChild(tile.getImage());
        s.x = x;
        s.y = y - 12;
        Lib.current.addChild(s);
        x += tileSz;
      }
      x = 0;
      y += tileSz;
    }
  }
  */
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
  public function getImage() {
    if (Math.random() > 0.5) {
      return World.tile1;
    } else if (Math.random() > 0.5) {
      return World.tile2;
    } else if (Math.random() > 0.5) {
      return World.tile3;
    } else {
      return World.tile4;
    }
  }
}

