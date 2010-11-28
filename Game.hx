import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.display.Graphics;
import flash.Lib;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.display.Sprite;
import flash.display.Bitmap;

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

  public static var tiles : Array<Tile>;

  public static function initTiles () {
    tiles = new Array<Tile>();
    for (i in 0...tilesh) {
      for (j in 0...tilesw) {
        var tileno = i*tilesw + j;
        var img:String;
        switch(tileno % 2) {
          case 0 : img =  'assets/tile_zebra.png';
          default : img = 'assets/tile_psychedelic.png';
        }
        
        var thistile = new Tile();
        //var loader = new Loader();
        //loader.load(new URLRequest(img));
        //loader.y = i*tilesize;
        //loader.x = j*tilesize;
        //thistile.image = loader;
        tiles[tileno] = thistile;
      }
    }
  }

  public static function drawTiles(tiles:Array<Tile>) {
    // XXX unhardcode
    trace("Drawing tiles.");
    for ( i in 0...30 ) {
      for (j in 0...30 ) {
        //trace("About to draw i = " + i + " j = " + j);
        var thistile:Tile = tiles[i*30+j];
        var tileb:Bitmap = cast thistile.getImage().content;
        var b = new Bitmap(tileb.bitmapData);
        var s = new Sprite();
        s.y = i * tilesize - 12; // 12-pixel overlap zone
        s.x = j * tilesize;
        s.addChild(b);
        Lib.current.addChild(s);
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
    try {
      rootmc = flash.Lib.current;    
      mainmc = new MovieClip(); 
      debugtf = new TextField();
      debugtf.width = 600;
      debugtf.height = 600;
      rootmc.addChild(mainmc);
      rootmc.addChild(debugtf);
      mainmc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );
      mainmc.stage.addEventListener(KeyboardEvent.KEY_DOWN, handlekeydown );

      //flash.Lib.setErrorHandler(Utils.myHandler);

      // 1. Read in the level file
      // 2. Parse it into arrays of tiles
      World.loadStuff();
      //World.initDrawWorld();

      // Not actually gonna draw tiles here. Right now we are drawing them from
      // loadStuff. Ugh.
      //initTiles();
      //drawTiles(tiles);
  //    flash.ui.Mouse.cursor.show();
     } catch ( s : String ) {
       trace("Exception (String): " + s);
     } catch ( unknown : Dynamic ) {
       trace("Exception (Dynamic): " + Std.string(unknown));
     }
   }
}
