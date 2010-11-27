import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.display.Graphics;
import flash.Lib;
import flash.display.Loader;
import flash.net.URLRequest;

import World.World;
import World.Tile;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

class Game {
  static var rootmc : MovieClip;
  static var mainmc : MovieClip;
  static var debugtf : TextField;  

  // game parameters
  static var screenw:Int = 600;
  static var screenh:Int = 600;
  
  static var tilesize:Int = Tile.size;
  static var tilesh = Math.round(screenh/tilesize);
  static var tilesw = Math.round(screenw/tilesize);

  static var tiles : Array<Array<Tile>>;

  static function initTiles () {
    for (i in 0...tilesh) {
      for (j in 0...tilesw) {
        var tileno = i*tilesw + j;
        var img:String;
        switch(tileno % 2) {
          case 0 : img =  'assets/tile_zebra.png';
          default : img = 'assets/tile_psychedelic.png';
        }
        
        var thistile = new Tile();
        var loader = new Loader();
        loader.load(new URLRequest(img));
        loader.x = i*tilesize;
        loader.y = j*tilesize;
        thistile.image = loader;
        tiles[i][j] = thistile;
      }
    }
  }

  static function drawTiles(tiles:Array<Array<Tile>>) {
    // XXX unhardcode
    for ( i in 0...30 ) {
      for (j in 0...30 ) {
        var thistile:Tile = tiles[i][j];
        Lib.current.addChild(thistile.image);
      }
    }
  }



  static function handleclick(event : MouseEvent) {
      debugtf.appendText("you mousedowned at " + event.localX + " " + event.localY + "\n");
  }

  static function handlekeydown(event : KeyboardEvent) {
      debugtf.appendText("you pushed this button: " + event + "\n"); 
      if(event.charCode == 100){ // 'd'
         debugtf.visible = !debugtf.visible;
      }     
  } 

  static function main() {
  
    rootmc = flash.Lib.current;    
    mainmc = new MovieClip(); 
    debugtf = new TextField();
    debugtf.width = 600;
    debugtf.height = 600;
    rootmc.addChild(mainmc);
    rootmc.addChild(debugtf);
    mainmc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );
    mainmc.stage.addEventListener(KeyboardEvent.KEY_DOWN, handlekeydown );

    // 1. Read in the level file
    // 2. Parse it into arrays of tiles
    initTiles();

    drawTiles(tiles);
//    flash.ui.Mouse.cursor.show();
   }
}
