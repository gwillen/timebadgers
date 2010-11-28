import Utils.Option;
import Utils;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.display.Bitmap;

typedef World_t = Array<Tile>;

typedef Coor = {
    var x : Int;
    var y : Int;
}   

class World {
  public static var tile1:Loader;
  public static var tile2:Loader;
  public static var tile3:Loader;
  public static var tile4:Loader;
  public static var loaded:Int;
  public static function loadStuff() {
    var bg = new Loader();
    bg.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    bg.load(new URLRequest("assets/background_nightsky.png"));
    Game.rootmc.addChild(bg);

    tile1 = new Loader();
    tile1.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile1.load(new URLRequest("assets/tile_zebra.png"));
    tile2 = new Loader();
    tile2.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile2.load(new URLRequest("assets/tile_suspensionbridge.png"));
    tile3 = new Loader();
    tile3.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile3.load(new URLRequest("assets/tile_movesup.png"));
    tile4 = new Loader();
    tile4.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
    tile4.load(new URLRequest("assets/tile_psychedelic.png"));
    trace("World loading stuff.");
  }

  static var worldState: World_t;

  public static function completeHandler(event : Event) {
    var loader:Loader = event.target.loader;
    loaded++;

    if (loaded == 5) {
      // Now everything is loaded. This is stupid.
      trace("Going to init tiles.");
      initTiles();
      //haxe.Timer.delay(drawTheTiles, 0);
    }
  }

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

class Tile {
  public static var size:Int = 20; // width and height
  public var image:flash.display.Loader;
  public var type:TileType;
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

