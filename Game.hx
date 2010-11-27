import flash.display.MovieClip;
import flash.display.Graphics;
import flash.Lib;
import flash.display.Loader;
import flash.net.URLRequest;

import flash.events.Event;
import flash.events.MouseEvent;

class Game {
  static var mc : MovieClip;
  // game parameters
  static var screenw = 600;
  static var screenh = 600;

  static var tiles : Array<World.Tile>;

  static function drawTiles(tiles:Array<World.Tile>) {
    for ( i in 0...30 ) {
      for (j in 0...30 ) {
        var tileno = i+j;
        var img:String;
        switch(tileno % 2) {
          case 0 : img =  'graphics/dummytile1.jpg';
          default : img = 'graphics/dummytile2.jpg';
        }
        var loader = new Loader();

        loader.load(new URLRequest(img));
        loader.x = i*20;
        loader.y = j*20;
        Lib.current.addChild(loader);
      }
    }
  }

  static function handleclick(event : MouseEvent) {
      trace("you mousedowned at " + event.localX + " " + event.localY);
  }

  static function main() {
    mc = flash.Lib.current;
    mc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );

    // 1. Read in the level file
    // 2. Parse it into arrays of tiles
    tiles = new Array<World.Tile>();

    drawTiles(tiles);
//    flash.ui.Mouse.cursor.show();
   }
}
