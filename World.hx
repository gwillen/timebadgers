import Utils.Option;
import Utils;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.display.Bitmap;

typedef World_t = Array<Tile>;

class World {
  public static var tile:Array<Ref<Loader>>;

  public static function loadStuff() {
    LoadStuff.loadTextFileAndCall("TILEMAP", function(x) { trace(x); });

    tile = new Array<Ref<Loader>>();
    for (i in 0...4) {
      tile[i] = new Ref(new Loader());
    }

    // call initTiles when the loading is all completed. XXX: it is no longer
    // really necessary to do this in this order, since all our logic is in
    // frameDidLoad or whatever, which won't get called till we return from
    // main (which is what's calling this to do the loading.)
    LoadStuff.startBatchLoad(initTiles);
    LoadStuff.batchLoadImage("assets/tile_xwindows.png", tile[0]);
    LoadStuff.batchLoadImage("assets/tile_suspensionbridge.png", tile[1]);
    LoadStuff.batchLoadImage("assets/tile_zebra.png", tile[2]);
    LoadStuff.batchLoadImage("assets/tile_psychedelic.png", tile[3]);
    LoadStuff.endBatchLoad();

    trace("World loading stuff.");
  }

  static var worldState: World_t;

  public static function drawTheTiles() {
    drawTiles(worldState);
  }

  public static function clearTheTiles() {
    while(Game.mainmc.numChildren > 0) {
      Game.mainmc.removeChildAt(0);
    }
  }

  // game parameters
  static var screenw:Int = 600;
  static var screenh:Int = 600;
  
  static var tilesize:Int = Tile.size;
  static var tilesh = Math.round(screenh/tilesize);
  static var tilesw = Math.round(screenw/tilesize);

  public static function initTiles () {
    trace("initTiles");
    worldState = new Array<Tile>();
    for (y in 0...tilesh) {
      for (x in 0...tilesw) {
        setTile(x, y, new Tile()); 
      }
    }
  }

  public static function drawTiles(tiles:Array<Tile>) {
    for ( y in 0...tilesh ) {
      for (x in 0...tilesw ) {
        var thistile:Tile = getTile(x, y);
        var tileb:Bitmap = cast thistile.getImage().content;
        var b = new Bitmap(tileb.bitmapData);
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
    return switch (getTile(x, y).type ) {   
      case TileType.floor: true;
      default : false;
    }
  }

  // Must work on invalid coords; return true;
  public static function canStandOn(w: World_t, x:Int, y:Int) :Bool {
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

class Tile {
  public static var size:Int = 20; // width and height
  public var image:flash.display.Loader;
  public var type:TileType;
  public function new() {}
  public function getImage() {
    if (Math.random() > 0.5) {
      return World.tile[0].val;
    } else if (Math.random() > 0.5) {
      return World.tile[1].val;
    } else if (Math.random() > 0.5) {
      return World.tile[2].val;
    } else {
      return World.tile[3].val;
    }
  }
}

