import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.display.Graphics;
import flash.Lib;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.display.Sprite;
import flash.display.Bitmap;

class DebugTextField extends TextField{

   public function new() {   
      super();
      width = 600;
      height = 600;
      alpha = 0.5;
      background = true;
      backgroundColor = 0xFFFFFF;
      visible = false;
   }

   public function trace(s : String) {
     appendText(s);


     while( numLines > 45){
       var t = text.substr(getLineLength(0));
       text = t;
      }
   }

}