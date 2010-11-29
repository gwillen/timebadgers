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
  // These are indices into the tile array.
  public static var NOTHING : Int = 0;
  public static var WALL : Int = 14;
  public static var MOVEDOWN : Int = 10;
  public static var MOVELEFT : Int = 11;
  public static var MOVERIGHT : Int = 12;
  public static var MOVEUP : Int = 13;
  public static var TURTLEL : Int = 0x0001;
  public static var TURTLER : Int = 0x0002;
  public static var TURTLELDEAD : Int = 0x0035;
  public static var TURTLERDEAD : Int = 0x0036;
  public static var CONVEYORL : Int = 0x0032;
  public static var CONVEYORR : Int = 0x0033;
  public static var GWILLEN : Int = 0x0042;

  public static var tilesLoaded : Bool = false;

  public static function loadStuff() {
    tileStyles = new Array<TileStyle>();
    allTiles = new Array<Tile>();
    // Danger: This call is async.

    LoadStuff.loadTileMap(tileStyles, function() {
      for (i in 0...tileStyles.length) {
        allTiles[i] = new Tile();
        allTiles[i].style = tileStyles[i];
	tilesLoaded = true;
        }
    });

    LoadStuff.loadImageAndCall("background_nightsky.png", function(l) {
      Game.setBackground(l);
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

    Game.debugtf.trace("World loading stuff.\n");
  }

  // Returns the tile that this thing should become if it dies.
  public static function deathTile(t : Int) : Int {
    switch(t) {	
      case 0x0001: return World.TURTLELDEAD;
      case 0x0002: return World.TURTLERDEAD;
      default: return World.NOTHING;
    }
  }

  public static var worldState: World_t;
  public static var tileStyles : Array<TileStyle>;
  public static var allTiles : Array<Tile>;

  public static function findAndRemoveBadgers(world : Array<Tile>) : Array<Coor> {
    var rv : Array<Coor> = new Array<Coor>();
    for (i in 0...world.length) {
      var c = tileCoords(i);
      if (world[i].style.prop.isbadger) {
          world[i] = allTiles[0];  // empty tile 
        rv.push(c);
      }
    }
    return rv;
  }

  public static function moveBadger(world : World_t, new_x, new_y)
  : Void {
    var badger = Option.none;
    for (i in 0...world.length) {
      if ( world[i].style.prop.isbadger) {
        badger = Option.some(world[i]);
        world[i].style = tileStyles[0]; // empty tile
        break;
      }
    }
    /*
    switch(badger) {
      case some(t): {
        trace("found a badger");
        for (i in 0...world.length) {
          if (new_x*30 + new_y == i) { // new badger location
            world[i] = t;
          }
        }
      }
      default: {
        trace("DID NOT FIND IT");
      }
    }
    */
  }

  public static function drawTheTiles(frame : Int) {
    drawTiles(worldState, frame);
  }

  public static function clearTheTiles() {
    while(Game.mainmc.numChildren > 0) {
      Game.mainmc.removeChildAt(0);
    }
  }

  // game parameters
  public static var screenw:Int = 600;
  public static var screenh:Int = 600;
  
  public static var tilesize:Int = Tile.size;
  public static var tilesh = Math.round(screenh/tilesize);
  public static var tilesw = Math.round(screenw/tilesize);

/*
  public static function initTiles () {
    Game.debugtf.trace("initTiles");
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
	if (thistile == null) {
	// 	  trace('NULL ASSHOLE');
	} else {
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
  }

  public static function tileIndex(x: Int, y: Int) : Int {
    return y*tilesw + x;
  }

  public static function tileCoords(index: Int) : Coor {
    return { x : index % tilesw, y : Math.floor(index / tilesw) };
  }

  public static function getTile(x:Int, y:Int) : Tile {
    return worldState[tileIndex(x, y)];
  }

  public static function getTileW(w: World_t, x:Int, y:Int) : Tile {
    return w[tileIndex(x, y)];
  }

  public static function setTile(x:Int, y:Int, t:Tile) {
    worldState[y*tilesw + x] = t;
  }

  // XXX
  // Must work on invalid coords; return true.
  public static function isBlocked(w: World_t, x:Int, y:Int) :Bool {
    if (x < 0 || x >= tilesw || y < 0 || y >= tilesh) {
      return true;
    } else {
      return getTileW(w,x, y).style.prop.solid;
    }
  }

  // XXX
  // Must work on invalid coords; return false;
  public static function canStandOn(w: World_t, x:Int, y:Int) :Bool {
    if (x < 0 || x >= tilesw || y < 0 || y >= tilesh) {
      return false;
    } else {
      return getTileW(w,x, y).style.prop.standon;
    }
  }

  /*XXX dummy
  public static function findBadgers() :Array<{x:Int, y:Int}> {
    return [{x:4, y:11}];
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

class TileFrame {
  public function new() {}
  public var filename : String;
  public var buf : BitmapData;
  public var delay : Int;
}

class TileProperties {
  public function new(bits : String) {
    standon = Utils.parseBool(bits.charAt(0));
    solid = Utils.parseBool(bits.charAt(1));
    isbadger = Utils.parseBool(bits.charAt(2));
    isturtle = Utils.parseBool(bits.charAt(3));
    conveyed = Utils.parseBool(bits.charAt(4));
    falls = Utils.parseBool(bits.charAt(5));
    nostep = Utils.parseBool(bits.charAt(6));
  }
  public var standon : Bool;
  public var solid : Bool;
  public var isbadger : Bool;
  public var isturtle : Bool;
  // Moved by conveyors.
  public var conveyed : Bool;
  // Falls if nothing's under it.
  public var falls : Bool;
  // If something lands on it, then it dies.
  public var nostep : Bool;
}

class TileStyle {
  public function new() {}
  public var frames : Array<TileFrame>;
  public var totalFrames : Int;  // Sum of all frames[i].delay
  public var prop : TileProperties;
  public var id : Int;
}

class Tile {
  public function new() {}
  public static var size:Int = 20; // width and height
  //public var type:TileType;
  public var style:TileStyle;
  public function getImage(frame : Int, x : Int, y : Int) {
    // Default animation mode is position-dependent
    var animFrame = (frame+x+y) % style.totalFrames;
    for (i in 0...style.frames.length) {
      animFrame -= style.frames[i].delay;
      if (animFrame < 0) {
        return style.frames[i].buf;
      }
    }
    throw("Malformed animation?");
    /*
    var styleNum : Int = Math.floor(Math.random() * World.tileStyles.length);
    try {
      return World.tileStyles[styleNum].frames[0].buf;
    } catch ( d : Dynamic ) {
      Game.debugtf.trace("Failed number was " + styleNum);
      //Game.debugtf.trace("Failed frame was " + World.tileStyles[styleNum].frames[0].filename);
      return World.tileStyles[0].frames[0].buf;
    }
    */
  }
}

