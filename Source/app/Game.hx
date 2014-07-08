package app;


import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.Lib;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.MovieClip;
 import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
 


class Game extends Sprite {
	
	
	private static var NUM_COLUMNS = 8;
	private static var NUM_ROWS = 8;
	private static var NUM_PIPES = 100;
	private static var NEAR_PIPE_DISTANCE:Float= 900;
	private static var PIPE_DISTANCE:Float= 450;
	private static var BIRD_X_DIRECTION_INT = 1 ;
	
	private static var BIRD_DISTANCE0_FLT:Float = 4; //8
	private static var BIRD_DISTANCE1_FLT:Float  = 4; //8
	private static var BIRD_PUSH_UP_FLT:Float  = 8; //16
	private static var BIRD_PUSH_DECREMENT_FLT:Float  = 0.5; //1
	private static var BIRD_PUSH_DECREMENT_DIRECTION_FLT:Float  = -1; //1
	
	private static var BIRD_Y_DIRECTION_FLT:Float = 1 ;
	private static var PUSH_Y_DIRECTION_FLT:Float = -1;
	
	private static var BIRD_ORIGIN_X:Float = 40 ;
	private static var BIRD_ORIGIN_Y:Float = 200 ;

	private var BIRD_SOUND_FRAME_LABEL:String = "chirp";
	private var ANDROID_FACTOR:Float = 0.5 ;
	
	
	 
	private var Background:Sprite;
	private var haze_Sp:Sprite;
	private var IntroSound:Sound;
	private var playButton_Bmp:Bitmap;
	private var replayButton_Bmp:Bitmap;
	private var nextLevelButton_Bmp:Bitmap;
	private var splashScreen_Bmp:Bitmap;
	
	private var debug_Txt:TextField;
	private var Score:TextField;
	private var Sound3:Sound;
	private var Sound4:Sound;
	private var Sound5:Sound;

	private var background_Sp:Sprite;
	private var pipeContainer_Sp:Sprite;
	private var pipeContainerNear_Sp:Sprite ;
	private var pipeContainerFar_Sp:Sprite ;
	
	private var buttonContainer_Sp:Sprite;
	private var splashScreenContainer_Sp:Sprite;
	
	private var background_Bmp:Bitmap ;
	private var bird_Bmp:Bitmap ;
	
	private var haze_Bmp:Bitmap ;
	
	private var birdContainer_Sp:Sprite;
	
	
	public var currentScore:Int;
	
	
	private var needToCheckMatches:Bool;
	
	 
	private var middlePipeArray_Arr:Array <Pipe>;
	private var pipeNearArray_Arr:Array <Pipe>;
	private var pipeFarArray_Arr:Array <Pipe>;
	
	private var pipeX_Flt:Float ; 
	private var startGame_Bool:Bool ;
	private var stage_S:Stage ;
	private var scaleHeight_Flt:Float;
	private var scaleWidth_Flt:Float  ;
	private var pushUp_Flt:Float ;
	private var bird_Mc:MovieClip;
	
	
	private var channel:SoundChannel;
 	private var themeSound:Sound;
 	private var sound:Sound;
	
	private var birdChirpSound_Snd:Sound ; 
	private var birdChirpChannel_Sc:SoundChannel; 
	private var birdChirpAllow_Bool:Bool ;
	
	private var position:Float;
	private var lastFarPipeX_Flt:Float ;
	private var lastMiddlePipeX_Flt:Float ;
	private var lastNearPipeX_Flt:Float ;
	private var levelMaxScore_Arr:Array<Int> ;
	private var currentLevel_Int:Int ;
	
	public function new () 
	{
		
		super ();
	
	}
	public function init(stage):Void 
	{
		resize(stage);
		initialize ();
	
	}
	
	
	private function initialize ():Void 
	{

		
		
		startGame_Bool = false ;
		
		 
		 
		middlePipeArray_Arr= new Array <Pipe> ();
		pipeNearArray_Arr= new Array <Pipe> ();
		pipeFarArray_Arr= new Array <Pipe> ();
		levelMaxScore_Arr = new Array<Int>(); 
		levelMaxScore_Arr[0] = 10;
		levelMaxScore_Arr[1] = 10;
		currentLevel_Int = 1;
 
		
		Background = new Sprite ();
		background_Bmp = new Bitmap (Assets.getBitmapData ("images/background0.png"));
		splashScreen_Bmp = new Bitmap(Assets.getBitmapData ("images/splash-screen.png"));
		replayButton_Bmp = new Bitmap (Assets.getBitmapData ("images/replay-button.png"));
		playButton_Bmp = new Bitmap (Assets.getBitmapData ("images/play-button.png"));
		nextLevelButton_Bmp = new Bitmap (Assets.getBitmapData ("images/next-level.png"));
		bird_Bmp = new Bitmap(Assets.getBitmapData ("images/bird.png"));
		haze_Bmp = new Bitmap(Assets.getBitmapData ("images/haze.png"));
		
		background_Bmp.smoothing = true; 
		haze_Bmp.smoothing = true; 
		replayButton_Bmp.smoothing = true ;
		playButton_Bmp.smoothing = true ;
		splashScreen_Bmp.smoothing = true; 
		bird_Bmp.smoothing = true; 
		
		
		Score = new TextField ();
		background_Sp = new Sprite();
		pipeContainer_Sp = new Sprite ();
		pipeContainerNear_Sp = new Sprite ();
		haze_Sp = new Sprite();
		pipeContainerFar_Sp = new Sprite ();
		splashScreenContainer_Sp = new Sprite();
		buttonContainer_Sp = new Sprite ();
		birdContainer_Sp = new Sprite();
		
		bird_Mc = new MovieClip();
		
		
		Assets.loadLibrary ("swflibId", assetLoaded);
		
	}
	
	private function assetLoaded(library:AssetLibrary):Void 
	{ 
			bird_Mc = Assets.getMovieClip ("swflibId:BirdSymbol");
			//addChild(bird_Mc);
			bird_Mc.x = 50;
			bird_Mc.y = 200;
			
				construct ();
				newGame ();
		
	}

	 
	
	
	private function construct ():Void 
	{
		background_Sp.addChild (background_Bmp);
		
		#if (!js || openfl_html5)
 				haze_Sp.filters = [ new BlurFilter (15, 15)];
 		#end
		
		haze_Sp.addChild(haze_Bmp);
		pipeContainerNear_Sp.mouseChildren = false ;
		pipeContainerNear_Sp.scaleX = 1;// 2 ;
		pipeContainerNear_Sp.scaleY = 1;// 2 ;
		
		pipeContainerFar_Sp.scaleX = 0.5 ;
		pipeContainerFar_Sp.scaleY = 0.5 ;
		
		addChild(background_Sp);
		addChild (pipeContainerFar_Sp);		
		addChild(haze_Sp);
		addChild (pipeContainer_Sp);
		addChild(bird_Mc);
		
		addChild (pipeContainerNear_Sp);
		
		
		

		
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
		
		IntroSound = Assets.getSound ("soundTheme");
		Sound3 = Assets.getSound ("sound3");
		Sound4 = Assets.getSound ("sound4");
		Sound5 = Assets.getSound ("sound5");
		
		birdChirpSound_Snd = Assets.getSound("chirp_Id");
		
		
		buttonContainer_Sp.addEventListener (MouseEvent.MOUSE_DOWN, playButton_onMouseUp);
		
		
		
		nextLevelButton_Bmp.smoothing = true ;
		

		Background.y = 0;
		Background.graphics.beginFill (0xFFFFFF, 0.4);
		Background.graphics.drawRect (0, 0, 700, 50);
		
		#if (!js || openfl_html5)
			addChild (Background);
		#end
		
		addScore();
		addChild(splashScreenContainer_Sp);
		addChild(buttonContainer_Sp);
		
		splashScreenContainer_Sp.x = (700 - splashScreen_Bmp.width) / 2  ;
		splashScreenContainer_Sp.y = (400 - splashScreen_Bmp.height) / 2 ;
		splashScreenContainer_Sp.addChild(splashScreen_Bmp);
		
		buttonContainer_Sp.x = (700 - playButton_Bmp.width) / 2  ;
		buttonContainer_Sp.y = (400 - playButton_Bmp.height) / 2 ;
		buttonContainer_Sp.addChild (playButton_Bmp);
		
		
		
		addDebugger();
		
		channel = IntroSound.play (0);
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
		
		
		  
	}
	
	
		private function birdChirpChannel_Sc_onSoundComplete(event:Event):Void 
		{
				birdChirpChannel_Sc.removeEventListener (Event.SOUND_COMPLETE, birdChirpChannel_Sc_onSoundComplete);
				birdChirpChannel_Sc.stop ();
				birdChirpAllow_Bool = true; 
		}
		
		private function channel_onSoundComplete (event:Event):Void 
		{
				channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
				
				channel.stop ();
				channel = null;
				
				channel = IntroSound.play(0);
				channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
 
		}
	
	
	private function addDebugger():Void 
	{
				var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 30, 0x000000);
		defaultFormat.align = TextFormatAlign.RIGHT;
		
		debug_Txt = new TextField();
 		debug_Txt.defaultTextFormat = defaultFormat;
  		debug_Txt.embedFonts = true;
	 
		addChild(debug_Txt);
	}
	private function addScore():Void 
	{
		
		var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 60, 0x000000);
		defaultFormat.align = TextFormatAlign.RIGHT;
		
		Score.x = 500 ;
		Score.width = 200;
		Score.y = 0;
		Score.selectable = false;
		Score.defaultTextFormat = defaultFormat;
  		Score.embedFonts = true;
		addChild (Score);
	}
	
	
	private function getPosition (row:Int, column:Int):Point 
	{
		
		return new Point (column * (57 + 16), row * (57 + 16));
		
	}
	public function randomRange( minNum:Int , maxNum:Int):Int 
	{
		return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
	}
 
	public function resize(stage:Stage):Void 
	{
		stage_S = stage;
		
		scaleWidth_Flt = stage.stageWidth / 700;
		scaleHeight_Flt =stage.stageHeight / 400;
		
		scaleX = scaleWidth_Flt;
		scaleY = scaleHeight_Flt ;
		
	}
	
	
	
	public function newGame ():Void 
	{
		
		birdChirpAllow_Bool = true ;
		currentScore = 0;
		Score.text = "0";
		bird_Mc.x = BIRD_ORIGIN_X;
		bird_Mc.y = BIRD_ORIGIN_Y;
		
		
		addAllPipes();
		
		
		
		//////////////////////////////////////////////////////////
 		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		
		
	}
	private function addAllPipes():Void 
	{
	
		//////////////////////////////////////////////////////////
		pipeX_Flt = PIPE_DISTANCE ;
		if ( pipeFarArray_Arr.length > 0)
		{
			for (index_int in 0...5)// NUM_PIPES) 
			{
					removeFarPipe(index_int);
			} 
	 	}
		
		for (index_int in 0...5)// NUM_PIPES) 
		{
  				addFarPipe(index_int);
  		} 
		lastFarPipeX_Flt = pipeFarArray_Arr[ pipeFarArray_Arr.length - 1].x ; 
		pipeContainerFar_Sp.x = 0; 
		
		//////////////////////////////////////////////////////////

		
		
		
		pipeX_Flt = PIPE_DISTANCE ;
		if ( middlePipeArray_Arr.length > 0)
		{
			for (index_int in 0...3)//NUM_PIPES) 
			{
					removeMiddlePipe(index_int);
			} 
	 	}
		
		for (index_int in 0...3 )//NUM_PIPES) 
		{
  				addMiddlePipe(index_int);
  		} 
		
		lastMiddlePipeX_Flt = middlePipeArray_Arr[ middlePipeArray_Arr.length - 1].x ; 
		pipeContainer_Sp.x = 0;
		
		//////////////////////////////////////////////////////////
		
	
		
		//////////////////////////////////////////////////////////
		pipeX_Flt = NEAR_PIPE_DISTANCE ;
		if ( pipeNearArray_Arr.length > 0)
		{
			for (index_int in 0...2)//NUM_PIPES) 
			{
					removeNearPipe(index_int);
			} 
	 	}
		
		for (index_int in 0...2)//NUM_PIPES) 
		{
  				addNearPipe(index_int);
  		} 
		
		lastNearPipeX_Flt = pipeNearArray_Arr[ pipeNearArray_Arr.length - 1].x ;
		
		pipeContainerNear_Sp.x = 0;
		
		
	}
	
		private function addMiddlePipe (index_param_int:Int):Void 
	{
		
 		var pipe = new Pipe();
 		pipe.initialize(currentLevel_Int,false);
		pipe.x = pipeX_Flt ;
		
		pipe.y = ( randomRange( Std.int(-250 ), Std.int( 0  ) ) ) ;
		pipeX_Flt += (PIPE_DISTANCE );//+ pipe.width  )  ;
		middlePipeArray_Arr[index_param_int] = pipe;
		pipeContainer_Sp.addChild(pipe);
		 
	}
	
	public function removeMiddlePipe (index_int:Int):Void 
	{
		
			var pipe = middlePipeArray_Arr[index_int];
		
			if (pipe != null) 
			{
				pipe.remove ();
  			}
		
		middlePipeArray_Arr[index_int] = null;
		
	}
	
	 
	private function addNearPipe (index_param_int:Int):Void 
	{
		var near_bool:Bool = true; 
 		var pipe = new Pipe();
 		pipe.initialize(currentLevel_Int,near_bool);
		pipe.x = pipeX_Flt ;
		pipe.y =  ( randomRange( Std.int( -500), Std.int( 0) ) ) ; // 50 = 100/2 , 500 = 250 * 2  , 2 is the scaling of near pillars
		pipeX_Flt += (NEAR_PIPE_DISTANCE);// + pipe.width  )  ;
		pipeNearArray_Arr[index_param_int] = pipe;
		pipeContainerNear_Sp.addChild(pipe);
		 
	}
		public function removeNearPipe (index_int:Int):Void 
	{
		
			var pipe = pipeNearArray_Arr[index_int];
		
			if (pipe != null) 
			{
				pipe.remove ();
  			}
		
			pipeNearArray_Arr[index_int] = null;
	}
	//////////////////////////////////////////////////////////////////////////////
	
 
	private function addFarPipe (index_param_int:Int):Void 
	{
		
 		var pipe = new Pipe();
 		pipe.initialize(currentLevel_Int,false);
		pipe.x = pipeX_Flt ;
		pipe.y = 0;// -( randomRange( Std.int(150), Std.int( 250) ) ) ; // 75 = 150/2 , 500 = 250 * 2  , 2 is the scaling of near pillars
		pipeX_Flt += (PIPE_DISTANCE);// + pipe.width  )  ;
		pipeFarArray_Arr[index_param_int] = pipe;
		pipeContainerFar_Sp.addChild(pipe);
		 
	}
	
	public function removeFarPipe (index_int:Int):Void 
	{
		
			var pipe = pipeFarArray_Arr[index_int];
		
			if (pipe != null) 
			{
				pipe.remove ();
  			}
		
			pipeFarArray_Arr[index_int] = null;
	}
	 
	private function playButton_onMouseUp (event:MouseEvent):Void 
	{
		pushUp_Flt = 0;
		
		startGame_Bool = true; 
		
			background_Sp.removeChild(background_Bmp);
			background_Bmp = new Bitmap (Assets.getBitmapData ("images/background"+ Std.string(currentLevel_Int-1) +".png"));
			background_Sp.addChild(background_Bmp);
			
			if ( splashScreen_Bmp.parent == splashScreenContainer_Sp)
			{
			splashScreenContainer_Sp.removeChild(splashScreen_Bmp);
			}
 		buttonContainer_Sp.removeChildAt(0);//(playButton_Bmp);
 		newGame();
 	}
	
	private function stage_onMouseUp (event:MouseEvent):Void 
	{
			if ( startGame_Bool)
			{
				Sound3.play();
				bird_Mc.play();
				pushUp_Flt = BIRD_PUSH_UP_FLT ;
			}
 	}
	
	
	private function this_onEnterFrame (event:Event):Void 
	{
		
		//debug_Txt.text = bird_Mc.currentLabel ;
		
		if ( startGame_Bool)
		{
			
				pipeContainer_Sp.x += ( -1 * ( BIRD_DISTANCE0_FLT * BIRD_X_DIRECTION_INT) ); 
				pipeContainerNear_Sp.x +=  (( -1 * ( BIRD_DISTANCE0_FLT * BIRD_X_DIRECTION_INT) ))*2 ; 
				pipeContainerFar_Sp.x +=  (( -1 * ( BIRD_DISTANCE0_FLT * BIRD_X_DIRECTION_INT) ))*0.5 ; 
				
				bird_Mc.y +=   ( BIRD_DISTANCE1_FLT * BIRD_Y_DIRECTION_FLT )  + (pushUp_Flt * PUSH_Y_DIRECTION_FLT ) ; 
				
				if ( pushUp_Flt > 0 )
				{
					pushUp_Flt += BIRD_PUSH_DECREMENT_FLT * BIRD_PUSH_DECREMENT_DIRECTION_FLT ;
				}
				else
				{
					bird_Mc.gotoAndStop(1);
				}
				
				var rnd = randomRange(0, 7);
				if ( birdChirpAllow_Bool && rnd== 0  )//&& bird_Mc.currentLabel == BIRD_SOUND_FRAME_LABEL )
				{
					birdChirpAllow_Bool = false ;
					birdChirpChannel_Sc= birdChirpSound_Snd.play();
					birdChirpChannel_Sc.addEventListener (Event.SOUND_COMPLETE, birdChirpChannel_Sc_onSoundComplete);
				}
 
					Score.text = Std.string (currentScore);
					addNextPipe();
				
				if ( bird_Mc.y > 400 || birdHitsWithPillar()  )
				{
						bird_Mc.gotoAndStop(1);
						gameOver();
				}
				
				if ( currentScore > levelMaxScore_Arr[currentLevel_Int-1] )
				{
					
					levelUp(); 
				}
		}
 		
	}
	
	
	
	private function addNextPipe():Void 
	{
		
		for ( index_int in 0...pipeFarArray_Arr.length)
		{
				if ( pipeContainerFar_Sp.x + (pipeFarArray_Arr[index_int].x * pipeContainerFar_Sp.scaleX ) < -100 )
				{
					pipeFarArray_Arr[index_int].x = lastFarPipeX_Flt +PIPE_DISTANCE ;
					lastFarPipeX_Flt = pipeFarArray_Arr[index_int].x ;
					break; 
				}
		}
		
		
		for (index_int in 0...middlePipeArray_Arr.length) 
		{
				if ( (pipeContainer_Sp.x+ middlePipeArray_Arr[index_int].x) < -100 )
				{
					middlePipeArray_Arr[index_int].x = lastMiddlePipeX_Flt  + PIPE_DISTANCE ;						
					middlePipeArray_Arr[index_int].y = ( randomRange( Std.int(-250 ), Std.int( 0  ) ) ) ;
					lastMiddlePipeX_Flt = middlePipeArray_Arr[index_int].x ;
					currentScore++;
					break;
				}
		}
		
		
		
		for ( index_int in 0...pipeNearArray_Arr.length)
		{
				if ( pipeContainerNear_Sp.x + (pipeNearArray_Arr[index_int].x * pipeContainerNear_Sp.scaleX ) < ( -200* pipeContainerNear_Sp.scaleX)  )
				//if ( pipeContainerNear_Sp.x + (pipeNearArray_Arr[index_int].x * pipeContainerNear_Sp.scaleX ) < ( -100* pipeContainerNear_Sp.scaleX)  )
				{
					pipeNearArray_Arr[index_int].x = lastNearPipeX_Flt + NEAR_PIPE_DISTANCE ;
					pipeNearArray_Arr[index_int].y = ( randomRange( Std.int(-500), Std.int( 0) ) ) ;
					lastNearPipeX_Flt = pipeNearArray_Arr[index_int].x ;
					break; 
				}
		}
		
	}
	
	
	private function birdHitsWithPillar():Bool
	{
		var val_bool:Bool = false ;
		
		var pt0x:Float = bird_Mc.x ; 
		var pt0y:Float = bird_Mc.y-20 ; 
		
		var pt1x:Float = bird_Mc.x + bird_Mc.width -30; 
		var pt1y:Float = bird_Mc.y -20;
		
		var pt2x:Float = bird_Mc.x + bird_Mc.width - 30; 
		var pt2y:Float = bird_Mc.y + bird_Mc.height -40;
		
		var pt3x:Float = bird_Mc.x  -20 ;
		var pt3y:Float = bird_Mc.y + bird_Mc.height  -40 ;
	
			for (index_int in 0...middlePipeArray_Arr.length) 
				{
					
					//pt0 pt3 colliding with right of up-down pillar
					if ( pt0x > pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x && pt0x < pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x +middlePipeArray_Arr[index_int].width )
					{
						if ( pt0y < (pipeContainer_Sp.y + middlePipeArray_Arr[index_int].y) + 300 )
						{
							val_bool = true;		
							break; 
						}
					}
					if ( pt3x > pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x && pt3x < pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x+ middlePipeArray_Arr[index_int].width )
					{
						if ( pt3y > (pipeContainer_Sp.y + middlePipeArray_Arr[index_int].y ) + 500 )
						{
							val_bool = true;		
							break; 
						}
					}
					
					//////////////////////////////////////////////////////////////////////
					
					//pt1 pt2 colliding with left of up-down pillar
					if ( pt1x > pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x && pt1x < pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x +middlePipeArray_Arr[index_int].width )
					{
						if ( pt1y < (pipeContainer_Sp.y + middlePipeArray_Arr[index_int].y) + 300 )
						{
							val_bool = true;		
							break; 
						}
						
						
					}
					if ( pt2x > pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x && pt2x < pipeContainer_Sp.x + middlePipeArray_Arr[index_int].x+ middlePipeArray_Arr[index_int].width )
					{
						if ( pt2y > (pipeContainer_Sp.y + middlePipeArray_Arr[index_int].y) + 500 )
						{
							val_bool = true;		
							break; 
						}
					}
					//pt1 pt2 colliding with left of up-down pillar
					
					
					
				}
 		
			if ( val_bool)
			{
				Sound4.play();
			}
				
		return val_bool ;
 		
	}
	
	
	private function levelUp():Void 
	{
		
			
			
			removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
			startGame_Bool = false ;
			bird_Mc.gotoAndStop(1);
			currentLevel_Int++ ;
			
		
			
			
			if ( currentLevel_Int == 3 )
			{
				currentLevel_Int = 1 ;
				buttonContainer_Sp.x = (700 - replayButton_Bmp.width) -10  ;
				buttonContainer_Sp.y = (400 - replayButton_Bmp.height) -10;
				buttonContainer_Sp.addChild (replayButton_Bmp);
			}
			else
			{
				buttonContainer_Sp.x = (700 - nextLevelButton_Bmp.width) -10  ;
				buttonContainer_Sp.y = (400 - nextLevelButton_Bmp.height) -10;
				buttonContainer_Sp.addChild (nextLevelButton_Bmp);
			}
			
 			
 	}
	 
	 
	
	function gameOver():Void 
	{
	
		buttonContainer_Sp.x = (700 - replayButton_Bmp.width) -10  ;
		buttonContainer_Sp.y = (400 - replayButton_Bmp.height) -10;
		startGame_Bool = false ;
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		
		 buttonContainer_Sp.addChild (replayButton_Bmp);
	}
	
	
	
}