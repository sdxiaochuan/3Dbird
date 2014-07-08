package app;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.system.Capabilities;
import flash.Lib;
import openfl.Assets;


class Main extends Sprite 
{

	private var background_Bmp:Bitmap;
	private var game:Game; 
	
	public function new () 
	{
		
		super ();
		initialize ();
		construct ();
		resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	private function initialize ():Void 
	{
		
	
		game = new Game ();
		game.init(stage);
		
	}
	
	
	private function construct ():Void 
	{
		
		addChild (game);
	}
	
	private function resize (newWidth:Int, newHeight:Int):Void 
	{
		
	}
	
	
	
	private function stage_onResize (event:Event):Void {
		
		resize (stage.stageWidth, stage.stageHeight);
		game.resize(stage);
	}
	
	
}
