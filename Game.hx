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
import DebugTextField;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

import Simulate;

enum GameState {
  initialization;
  titleScreen;
  gamePlay;
}

class Game {

  public static var WORLD_HEIGHT = 600;
  public static var WORLD_WIDTH = 600;

  public static var rootmc : MovieClip;
  public static var mainmc : MovieClip;
  public static var backgroundmc : MovieClip;
  public static var debugtf : DebugTextField;  

  public static var lastClick;
  static function handleclick(event : MouseEvent) {
      lastClick = event;
      debugtf.trace("you mousedowned at " + event.localX + " " + event.localY + "\n");
  }

  public static var lastKey;
  static function handlekeydown(event : KeyboardEvent) {
      lastKey = event;
      debugtf.trace("you pushed this button: " + event.charCode + " " +
      event.keyCode + "\n"); 
      if(event.charCode == 100){ // 'd'
         debugtf.visible = !debugtf.visible;
      }     
      if(event.keyCode == 39) { // ->
      // XXX make badger move right
        trace("moveright");
      }
      if(event.keyCode == 37) { // <-
      // XXX make badger move left
        trace("moveleft");
      }
  } 

  // XXX this will wrap stupidly and everything will be ruined forever
  static var frame : Int = 0;
  static function mainLoop(e : Event) {
    // race condition lol
    //trace('mainloop:');
    if (gamestate == initialization) {
      return;
    } else if (gamestate == titleScreen) {
      if (lastClick == null && lastKey == null) {
        return;
      } else {
        gamestate = GameState.gamePlay;
        startGame();
        return;
      }
    }

    if (!LoadStuff.loadsDone() ||
        !World.tilesLoaded) {
      return;
    }
    // trace('clearthetiles:');
    World.clearTheTiles();
    // trace('drawthetiles:');
    World.drawTheTiles(frame++);
//    var badger_coord = World.findBadgers()[0]; //XXX
    var badger_coord = World.findAndRemoveBadgers(World.worldState)[1]; //XXX
    var badg_x = badger_coord.x;
    var badg_y = badger_coord.y;
    //trace ("badger x = " + badg_x + " and y = " + badg_y);
    var state0 = World.worldState;
    var state1 = World.worldState;
    var jump_dests = Utils.map(function(j:Jump.Jmp) { return j.dest; },
                                Jump.validJumps(state0, state1, badg_x, badg_y));
//    jump_dests = [{x:5, y:5}];                                
    Simulate.drawMovesRel(badg_x, badg_y, jump_dests);

    // This is retardo -- you need to do this as part of PROPOSAL X.
    if ((frame % 5) == 0) {
      World.worldState = Simulate.step(World.worldState);
    }
  }

  private static function myTrace( v : Dynamic, ?inf : haxe.PosInfos ) {
    debugtf.trace(v+"\n");
  }

  public static var gamestate = initialization;

  static function main() {
    try {
      haxe.Log.trace = myTrace;

      rootmc = flash.Lib.current;    
      mainmc = new MovieClip(); 
      backgroundmc = new MovieClip();
      mainmc.addEventListener(Event.ENTER_FRAME, mainLoop);
      debugtf = new DebugTextField();
      rootmc.addChild(backgroundmc);
      rootmc.addChild(mainmc);
      rootmc.addChild(debugtf);
      mainmc.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleclick );
      mainmc.stage.addEventListener(KeyboardEvent.KEY_DOWN, handlekeydown );

      LoadStuff.loadImageAndCall("title.png", function(l) {
        Game.setBackground(l);
      });

      gamestate = titleScreen;
      //flash.Lib.setErrorHandler(Utils.myHandler);
    } catch ( s : String ) {
      trace("Exception (String): " + s);
    } catch ( unknown : Dynamic ) {
      trace("Exception (Dynamic): " + Std.string(unknown));
    }
  }  

  public static function setBackground(l:flash.display.DisplayObject) {
    while (backgroundmc.numChildren > 0) {
      backgroundmc.removeChildAt(0);
    }
    backgroundmc.addChild(l);
  }

  static function startGame() {
    Achievements.init();
    World.loadStuff();
  }
}
