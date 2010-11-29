import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Achievements {
  static var ach = new Hash<{ name : String, desc : String, achieved : Bool}>();
  static var displaybox : AchievementTextField;

  public static function init() {
    displaybox = new AchievementTextField(); 
    Game.rootmc.addChild(displaybox);
    add("killturt", "You killed a turtle!");
    add("killgwill", "You killed a gwillen!");
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
      displaybox.set("Achievement unlocked:\n" + a.desc);
    }
  }

  public static function tick() {
    displaybox.tick();
  }
}

class AchievementTextField extends TextField{

   public function new() {   
      super();
      width = 300;
      height = 66;
      x = (600 - width)/2;
      y = (600 - height)/2;
      textColor = 0x0000CF;
      selectable = false;
      defaultTextFormat = new TextFormat("Comic Sans", 30, null, null, null, null, null, null, TextFormatAlign.CENTER);
      background = true;
      backgroundColor = 0xFFFFFF;
      visible = false;
      alpha = 0.4;
   }

   public function set(s : String) {
     text = s;
     timer = 20;
     visible = true;
   }

   public function tick() {
     if (timer > 0) {
       timer--;
     } else {
       visible = false;
     }
   }

   static var timer : Int = 0;
}
