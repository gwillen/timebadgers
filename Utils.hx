class Utils {
  function map<T> (f, l : Array<T>) : Array<T>{
    var rv : Array<T> = new Array<T>();
    for (it in l) {
      rv.push(f(l));
    }
    return rv;
  }
}

enum Option<T> {
  none;
  some(t:T);
}

