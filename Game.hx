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

import Simulate;

class Game {

  public static var WORLD_HEIGHT = 600;
  public static var WORLD_WIDTH = 600;

  public static var rootmc : MovieClip;
  public static var mainmc : MovieClip;
  static var debugtf : TextField;  

  static function handleclick(event : MouseEvent) {
      debugtf.appendText("you mousedowned at " + event.localX + " " + event.localY + "\n");
  }

  static function handlekeydown(event : KeyboardEvent) {
      debugtf.appendText("you pushed this button: " + event + "\n"); 
      if(event.charCode == 100){ // 'd'
         debugtf.visible = !debugtf.visible;
      }     
  } 

  static function mainLoop(e : Event) {
    World.clearTheTiles();
    World.drawTheTiles();
  }

  static function main() {
    try {
      rootmc = flash.Lib.current;    
      mainmc = new MovieClip(); 
      mainmc.addEventListener(Event.ENTER_FRAME, mainLoop);
      debugtf = new TextField();
/*
      debugtf.width = WORLD_HEIGHT;
      debugtf.height = WORLD_WIDTH;
      rootmc.addChild(mainmc);
      rootmc.addChild(debugtf);
      mainmc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );
      mainmc.stage.addEventListener(KeyboardEvent.KEY_DOWN, handlekeydown );
*/
      debugtf.width = 600;
      debugtf.height = 600;


      //flash.Lib.setErrorHandler(Utils.myHandler);

      World.loadStuff();
      //World.initDrawWorld();
      rootmc.addChild(mainmc);
      rootmc.addChild(debugtf);
      mainmc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );
      mainmc.stage.addEventListener(KeyboardEvent.KEY_DOWN, handlekeydown );

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
