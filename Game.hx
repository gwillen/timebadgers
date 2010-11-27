import flash.display.MovieClip;
import flash.display.Graphics;

class Game {
  static var mc : MovieClip;
  // game parameters
  static var screenw = 600;
  static var screenh = 600;

  static var tiles : Array<Tile>;

  static function drawTiles() {

  }

  static function main() {
    mc = flash.Lib.current;

    // 1. Read in the level file
    // 2. Parse it into arrays of tiles
    tiles = new Array<Tile>();

    // 3. Draw the tiles
    for ( i in 0...30 ) {
      for (j in 0...30 ) {
        var tileno = 30*i + j;
        var color = 0xFF0000;
        switch(tileno % 3) {
          case 1 : color =  0xFFFFFF;
          case 2 : color =  0x000000;
        }
        mc.graphics.beginFill(color);
        mc.graphics.moveTo(i*20,j*20);
        mc.graphics.lineTo(i*20,j*20+20);
        mc.graphics.lineTo(i*20+20,j*20);
        mc.graphics.endFill();
      }
    }
  }
}
