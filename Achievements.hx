class Achievements {
  static var ach = new Hash<{ name : String, desc : String, achieved : Bool}>();

  public static function init() {
    add("killturt", "You killed a turtle!");
  }

  static function add(name : String, desc : String) { 
    if (!ach.exists(name)) {
      ach.set(name, { name : name, desc : desc, achieved : false });
    }
  }

  public static function got(name : String) {
    var a = ach.get(name);
    if (a.achieved == false) {
      a.achieved = true;
      ach.set(name, a);
      trace("Player got achievement: " + a.desc);
    }
  }
}
