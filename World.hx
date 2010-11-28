import Utils.Option;
import Utils;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.display.Bitmap;

typedef World_t = Array<Tile>;

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

  static var worldState: World_t;

  public static function completeHandler(event : Event) {
    var loader:Loader = event.target.loader;
    loaded++;

    if (loaded == 4) {
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
    for (i in 0...tilesh) {
      for (j in 0...tilesw) {
        var tileno = i*tilesw + j;
        
        var thistile = new Tile();
        worldState[tileno] = thistile;
      }
    }
  }

  public static function drawTiles(tiles:Array<Tile>) {
    // XXX unhardcode
    trace("Drawing tiles.");
    for ( i in 0...30 ) {
      for (j in 0...30 ) {
        //trace("About to draw i = " + i + " j = " + j);
        var thistile:Tile = tiles[i*30+j];
        var tileb:Bitmap = cast thistile.getImage().content;
        var b = new Bitmap(tileb.bitmapData);
        var s = new Sprite();
        s.y = i * tilesize - 12; // 12-pixel overlap zone
        s.x = j * tilesize;
        s.addChild(b);
        Game.mainmc.addChild(s);
      }
    }
  }




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
/*
  static function isBlocked(w: World, x:Int, y: Int) {
    return switch (w[x][y] ) {   
      case floor: true;
      otherwise : false;
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

