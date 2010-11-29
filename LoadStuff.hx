import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.display.Loader;
import flash.events.Event;
import Utils;
import flash.display.Bitmap;
import World;

class LoadStuff {
  public static function loadLevel(filename : String, level : Array<Tile>) {
    filename = "maps/" + filename;
    loadTextFileAndCall(filename, function(x) { processLevel(x, level); });
  }

  public static function processLevel(levelfile : String, level : Array<Tile>) {
    var tilecodes : Array<String> = levelfile.split("\n").join(" ").split(" ");
    if (tilecodes[tilecodes.length-1] == "") {
      // newline at end of file
      tilecodes.pop();
    }
    trace("a");
    var tilenums : Array<Int> = Utils.map(Utils.parseHex, tilecodes);
    for (i in tilenums) {
      var t = new Tile();
      t.style = World.tileStyles[i];
      level.push(t);
    }
    trace("a");
  }

  public static function loadTileMap(styles : Array<TileStyle>, ?cb) {
    loadTextFileAndCall("TILEMAP", function (x) {
      processTileMap(x, styles);
      if (cb != null) { cb(); }
    });
  }

  public static function processTileMap(tilemap : String, tilestyles : Array<TileStyle>) {
    // Is there a \r problem here?
    var lines : Array<String> = tilemap.split("\n");
    Game.debugtf.trace("processing tilemap");
    for (line in lines) {
      if (line == "") {
        break;
      }
      var style = new TileStyle();
      style.frames = new Array<TileFrame>();

      var words : Array<String> = line.split(" ");
      var id = Utils.parseHex(words.shift());
      var bitsstr = words.shift();
      style.prop = new TileProperties(bitsstr);
      style.id = id;
      // XXX need to use the bitstr
      while (words.length > 0) {
        var filename = words.shift();
        var delay = words.shift();
        var frame : TileFrame = new TileFrame();
        style.frames.push(frame);
        frame.delay = Std.parseInt(delay);
        style.totalFrames += frame.delay;
        frame.filename = filename;
        loadImageAndCall(filename, function (l) {
          var bitmap : Bitmap = cast l.content;
          frame.buf = bitmap.bitmapData;
        });
      }
      tilestyles[id] = style;
    }
  }

  static var count : Int;
  static var batchCompleteHandler;
 
  public static function loadsDone() {
    return (count == 0); // Race condition!
  }

  public static function startBatchLoad(handler) {
    count = 1;
    batchCompleteHandler = handler;
  }

  public static function endBatchLoad() {
    count--;
    if (count == 0) {
      batchCompleteHandler();
    }
  }

  public static function batchOneLoadedHandler() {
    count--;
    Game.debugtf.trace("Loader finished one; count is now " + count);
    if (count == 0) {
      batchCompleteHandler();
    }
  }

  //public static void loadTextFileBatch(buf : Array<String>) { }

  public static function batchLoadImage(filename : String, l : Ref<Loader> ) {
    count++;
    loadImageAndCall(filename, function(loader) {
      l.val = loader;
      batchOneLoadedHandler();
    });
  }

  // Load the specified file and pass its contents to f as a string.
  public static function loadTextFileAndCall(filename : String, f) {
    var request = new URLRequest();
    request.url = filename;
    var loader = new URLLoader();
    loader.addEventListener(Event.COMPLETE, function(e : Event) {
      f(e.target.data);
    });
    loader.load(request);
  }

  // Load the specified file and pass its loader to f.
  public static function loadImageAndCall(filename : String, f) {
    var loader = new Loader();
    filename = "assets/" + filename;
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) {
      f(e.target.loader);
    });
    loader.load(new URLRequest(filename));
  }
}

