import flash.text.TextField;
import flash.text.TextFormat;

class Achievements {
  static var ach = new Hash<{ name : String, desc : String, achieved : Bool}>();
  static var displaybox : AchievementTextField;

  public static function init() {
    displaybox = new AchievementTextField(); 
    Game.rootmc.addChild(displaybox);
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
      displaybox.set("Acheivement unlocked: " + a.desc);
    }
  }
}

class AchievementTextField extends TextField{

   public function new() {   
      super();
      width = 500;
      height = 500;
      x = 50;
      y = 50;
      textColor = 0x0000CF;
      defaultTextFormat = new TextFormat(null, 30);
      background = false;
   }

   public function set(s : String) {
     text = s;
   }

}
