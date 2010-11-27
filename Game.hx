import flash.display.MovieClip;
import flash.display.Graphics;
import flash.Lib;
import flash.display.Loader;
import flash.net.URLRequest;

import World.Tile;

class Game {
  static var mc : MovieClip;
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

  static function main() {
    mc = flash.Lib.current;

    // 1. Read in the level file
    // 2. Parse it into arrays of tiles
    initTiles();

    drawTiles(tiles);
  }
}
