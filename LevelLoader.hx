package levelloader;
import flash.Lib;
import flash.net.URLRequest;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;

class LevelLoader {
  function new(file : String) {
    var data_loader = new URLLoader();
    data_loader.dataFormat = URLLoaderDataFormat.TEXT;
    data_loader.addEventListener(Event.COMPLETE, loadComplete);
    var url = new URLRequest("level1.txt");
    
