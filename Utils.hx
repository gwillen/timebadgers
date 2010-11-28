class Utils {
  public static function map<T> (f, l : Array<T>) : Array<T>{
    var rv : Array<T> = new Array<T>();
    for (it in l) {
      rv.push(f(l));
    }
    return rv;
  }

  public static function halt() {
    while(true) {}
  }

/*
  public static function stackTrace (as : Array<String>) : String {
    var s = new String();
    for (i in as) {
      s.append(i);
    }
    return s;
  }

  public static function myHandler(msg : String, stack : Array<String>) {
    trace("We done fucked up: " + msg);
    trace(stackTrace(stack));
  }
  */
  //public static function dump(o : Dynamic) {
  //  for (i in o) {
  //  }
  //}
}

enum Option<T> {
  none;
  some(t:T);
}

class Ref<T> {
  public var val : T;
  public function new(t : T) {
    val = t;
  }
}
