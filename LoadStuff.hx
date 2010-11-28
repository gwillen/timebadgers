import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.display.Loader;
import flash.events.Event;
import Utils;
import flash.display.Bitmap;
import World;

class LoadStuff {
  public static function loadTileMap(styles : Array<TileStyle>) {
    loadTextFileAndCall("TILEMAP", function (x) { processTileMap(x, styles); });
  }

  public static function processTileMap(tilemap : String, tilestyles : Array<TileStyle>) {
    // Is there a \r problem here?
    var lines : Array<String> = tilemap.split("\n");
    var counter : Int = 0;
    trace("processing tilemap");
    for (line in lines) {
      if (line == "") {
        break;
      }
      var style = new TileStyle();
      style.frames = new Array<TileFrame>();

      var words : Array<String> = line.split(" ");
      var idstr = words.shift();
      var bitsstr = words.shift();
      while (words.length > 0) {
        var filename = words.shift();
        var delay = words.shift();
        var frame : TileFrame = new TileFrame();
        style.frames.push(frame);
        frame.delay = Std.parseInt(delay);
        frame.filename = filename;
        trace("filename is |" + filename + "|");
        loadImageAndCall(filename, function (l) {
          var bitmap : Bitmap = cast l.content;
          frame.buf = bitmap.bitmapData;
          trace("loaded buf");
          trace(frame.buf);
        });
      }
      tilestyles[counter] = style;
      counter++;
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
    trace("Loader finished one; count is now " + count);
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
    trace("Beginning load of " + filename);
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) {
      trace("done load of " + filename);
      trace("content is " + e.target.loader.content);
      f(e.target.loader);
    });
    loader.load(new URLRequest(filename));
  }
}

