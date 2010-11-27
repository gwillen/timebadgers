class Test {
  static function main() {
//    trace ("Hello world !");
    var mc:flash.display.MovieClip = flash.Lib.current;
    // type annotation not necessary
    mc.graphics.beginFill(0xFF0000);
    mc.graphics.moveTo(50,50);
    mc.graphics.lineTo(100,50);
    mc.graphics.lineTo(100,100);
    mc.graphics.lineTo(50,100);
    mc.graphics.endFill();
  }
}
