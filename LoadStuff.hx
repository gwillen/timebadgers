import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.display.Loader;
import flash.events.Event;
import Utils;

class LoadStuff {
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
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) {
      trace("load complete, loader = " + e.target.loader);
      trace("content is " + e.target.loader.content);
      f(e.target.loader);
    });
    loader.load(new URLRequest(filename));
  }
}

