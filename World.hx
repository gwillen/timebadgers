import Utils.Option;
import Utils;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.display.Bitmap;
import flash.display.BitmapData;

typedef World_t = Array<Tile>;

typedef Coor = {
    var x : Int;
    var y : Int;
}   

class World {
  public static var tile:Array<Ref<Loader>>;

  public static function loadStuff() {
    tileStyles = new Array<TileStyle>();
    // Danger: This call is async.
    LoadStuff.loadTileMap(tileStyles);

    LoadStuff.loadImageAndCall("background_nightsky.png", function(l) {
      Game.rootmc.addChildAt(l, 0);
    });

    // Also async
    worldState = new Array<Tile>();
    LoadStuff.loadLevel("skyline1.map", worldState);

    // call initTiles when the loading is all completed. XXX: it is no longer
    // really necessary to do this in this order, since all our logic is in
    // frameDidLoad or whatever, which won't get called till we return from
    // main (which is what's calling this to do the loading.)
    /*
    LoadStuff.startBatchLoad(initTiles);
    LoadStuff.batchLoadImage("assets/tile_xwindows.png", tile[0]);
    LoadStuff.batchLoadImage("assets/tile_suspensionbridge.png", tile[1]);
    LoadStuff.batchLoadImage("assets/tile_zebra.png", tile[2]);
    LoadStuff.batchLoadImage("assets/tile_psychedelic.png", tile[3]);
    LoadStuff.endBatchLoad();
    */
    //initTiles();

    trace("World loading stuff.");
  }

  static var worldState: World_t;
  public static var tileStyles : Array<TileStyle>;

  public static function drawTheTiles(frame : Int) {
    drawTiles(worldState, frame);
  }

  public static function clearTheTiles() {
    while(Game.mainmc.numChildren > 0) {
      Game.mainmc.removeChildAt(0);
    }
  }

  // game parameters
  static var screenw:Int = 600;
  static var screenh:Int = 600;
  
  public static var tilesize:Int = Tile.size;
  static var tilesh = Math.round(screenh/tilesize);
  static var tilesw = Math.round(screenw/tilesize);

/*
  public static function initTiles () {
    trace("initTiles");
    worldState = new Array<Tile>();
    for (y in 0...tilesh) {
      for (x in 0...tilesw) {
        setTile(x, y, new Tile()); 
      }
    }
  }
  */

  public static function drawTiles(tiles : Array<Tile>, frame : Int) {
    for (y in 0...tilesh) {
      for (x in 0...tilesw) {
        var thistile:Tile = getTile(x, y);
        var tileb = thistile.getImage(frame, x, y);
        var b = new Bitmap(tileb);
        var s = new Sprite();
        s.x = x * tilesize;
        s.y = y * tilesize - 12; // 12-pixel overlap zone
        s.addChild(b);
        Game.mainmc.addChild(s);
      }
    }
  }

  public static function getTile(x:Int, y:Int) : Tile {
    return worldState[y*tilesw + x];
  }

  public static function setTile(x:Int, y:Int, t:Tile) {
    worldState[y*tilesw + x] = t;
  }

  // Must work on invalid coords; return true.
  public static function isBlocked(w: World_t, x:Int, y:Int) :Bool {
   if (x < 0 || x >= tilesw || y < 0 || y >= tilesh) { return true;}
    else    
    return switch (getTile(x, y).type ) {   
      case TileType.floor: true;
      default : false;
    }
  }

  // Must work on invalid coords; return true;
  public static function canStandOn(w: World_t, x:Int, y:Int) :Bool {
   if (x < 0 || x >= tilesw || y < 0 || y >= tilesh) { return false;}
    else    
    return switch (getTile(x, y).type ) {   
      case TileType.floor: true; 
      //XXX also bridges
      default : false;
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

class TileFrame {
  public function new() {}
  public var filename : String;
  public var buf : BitmapData;
  public var delay : Int;
}

class TileStyle {
  public function new() {}
  public var frames : Array<TileFrame>;
  public var standon : Bool;
  public var solid : Bool;
}

class Tile {
  public function new() {}
  public static var size:Int = 20; // width and height
  public var type:TileType;
  public var style:TileStyle;
  public function getImage(frame : Int, x : Int, y : Int) {
    var animFrame = frame % style.frames.length;
    return style.frames[animFrame].buf;
    /*
    var styleNum : Int = Math.floor(Math.random() * World.tileStyles.length);
    try {
      return World.tileStyles[styleNum].frames[0].buf;
    } catch ( d : Dynamic ) {
      trace("Failed frame was " + World.tileStyles[styleNum].frames[0].filename);
      return World.tileStyles[0].frames[0].buf;
    }
    */
  }
}

