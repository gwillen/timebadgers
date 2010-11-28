class Utils {
  public static function map<T,U> (f : U -> T, l : Array<U>) : Array<T>{
    var rv : Array<T> = new Array<T>();
    for (it in l) {
      rv.push(f(it));
    }
    return rv;
  }

  public static function halt() {
    while(true) {}
  }

  public static function parseBool (digit : String) : Bool {
    switch(digit) {
      case "0":
        return false;
      case "1":
        return true;
    }
    throw("bad bool");
  }

  static function parseHexDigit (digit : String) : Int {
    switch(digit) {
      case "0":
        return 0;
      case "1":
        return 1;
      case "2":
        return 2;
      case "3":
        return 3;
      case "4":
        return 4;
      case "5":
        return 5;
      case "6":
        return 6;
      case "7":
        return 7;
      case "8":
        return 8;
      case "9":
        return 9;
      case "a", "A":
        return 10;
      case "b", "B":
        return 11;
      case "c", "C":
        return 12;
      case "d", "D":
        return 13;
      case "e", "E":
        return 14;
      case "f", "F":
        return 15;
    }
    throw("Bad hex digit");
  }

  public static function parseHex (hex : String) : Int {
    var rv : Int = 0;
    while (hex.length > 0) {
      var digit = hex.substr(0, 1);
      hex = hex.substr(1);
      rv *= 16;
      rv += parseHexDigit(digit);
    }
    return rv;
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
