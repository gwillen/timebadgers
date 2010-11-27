class Utils {
  public static function map<T> (f, l : Array<T>) : Array<T>{
    var rv : Array<T> = new Array<T>();
    for (it in l) {
      rv.push(f(l));
    }
    return rv;
  }

  //public static function dump(o : Dynamic) {
  //  for (i in o) {
  //  }
  //}
}

enum Option<T> {
  none;
  some(t:T);
}

