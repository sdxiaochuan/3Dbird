package app;


import flash.display.Bitmap;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import openfl.Assets;
import openfl.filters.BlurFilter;


class Pipe extends Sprite {
	
	
	public var column:Int;
	public var moving:Bool;
	public var removed:Bool;
	public var row:Int;
	public var type:Int;
	private var pipeContainer_Sp:Sprite ;
	private var imageName_Arr:Array <String>;
	private var currentLevel_Int:Int ;
	
	public function new () {
		
		super ();
		imageName_Arr = new Array <String>();
		imageName_Arr[0] = "pipe";
		imageName_Arr[1] = "log";
		
		pipeContainer_Sp = new Sprite();
		addChild(pipeContainer_Sp);
	}
	
	public function randomRange( minNum:Int , maxNum:Int):Int 
	{
		return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
	}
	
	public function initialize ( currentLevel_param_int:Int, near_bool:Bool ):Void 
	{
				
		var image_bmp ;
		
		currentLevel_Int = currentLevel_param_int;
		/*
		 #if (!js || openfl_html5)
		
			if ( blur_param_bool )
			{
				image_bmp = new Bitmap (Assets.getBitmapData ("images/pipe.png"));
				
				//pipeContainer_Sp.filters = [ new BlurFilter (15, 15)];
			}
			else
			{
				image_bmp = new Bitmap (Assets.getBitmapData ("images/pipe.png"));
			}
			
		#end
		
		*/
		var random_int:Int =0 ;
		if ( currentLevel_Int == 1 )
		{
			random_int = 0;
		}
		else
		if ( currentLevel_Int==2)
		{
			random_int =  randomRange(0, 2);
		}
		
			if ( near_bool)
			{
				image_bmp = new Bitmap (Assets.getBitmapData ("images/near-" + imageName_Arr[currentLevel_Int - 1] + random_int + ".png"));
			}
			else
			{
				image_bmp = new Bitmap (Assets.getBitmapData ("images/" + imageName_Arr[currentLevel_Int - 1] + random_int + ".png"));
			}
			
			image_bmp.smoothing = true;
		pipeContainer_Sp.addChild (image_bmp);
		
		
		mouseChildren = false;
		//buttonMode = true;
		
	//	graphics.beginFill (0x000000, 0);
	//	graphics.drawRect (-5, -5, 66, 66);
		
		
		
		moving = false;
		removed = false;
	 	
		#if (!js || openfl_html5)
		/*scaleX = 1;
		scaleY = 1;
		alpha = 1;*/
		#end
		
	}
	
	
	public function moveTo (duration:Float, targetX:Float, targetY:Float):Void {
		
		moving = true;
 		
	}
	
	
	public function remove ():Void 
	{
	 
		
		if (!removed) 
		{
				this_onRemoveComplete ();
		}
		
		removed = true;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onMoveToComplete ():Void 
	{
		
		moving = false;
		
	}
	
	
	private function this_onRemoveComplete ():Void 
	{
		
		parent.removeChild (this);
		
	}
	
	
}