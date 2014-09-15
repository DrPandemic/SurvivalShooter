package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class LevelEndAnimation extends MovieClip {
		private const WON_FRAME:int = 2;
		private const LOST_FRAME:int = 1;
		
		private const ANIMATION_LENGTH_MILLISECONDS:Number = 1500;
		private const ANIMATION_FRAMES:Number = ANIMATION_LENGTH_MILLISECONDS / GameScreen.MILLISECS_PER_FRAME;
		
		private var playerWon:Boolean;
		private var frames:int;
		private var level:Number;
		
		public function LevelEndAnimation(level:Number, playerWon:Boolean) {
			this.playerWon = playerWon;
			this.level = level;
			frames = 0;
			
			gotoAndStop(playerWon ? WON_FRAME : LOST_FRAME);
			alpha = 0;
			
			InputEventCannon.mainInstance.addEventListener(InputEventCannon.UPDATE, update, false,0,true);
		}
		
		private function update(e:Event):void
		{
			var percent:Number = (Number)(frames) / ANIMATION_FRAMES;
			alpha = percent; // fade-in
			
			if (percent >= 1.0) { // if we're done animating
				animDone();
			}
			
			++frames;
		}
		
		private function animDone():void
		{
			InputEventCannon.mainInstance.removeEventListener(InputEventCannon.UPDATE, update);
			
			InputEventCannon.mainInstance.pause(); // stop the game
			
			if (playerWon) { // player won
				var winScreen:LevelWinScreen = new LevelWinScreen(level);
				parent.addChild(winScreen);
			}
			else { // player lost
				var deathScreen:DeathScreen = new DeathScreen();
				parent.addChild(deathScreen);
			}
			
			parent.removeChild(this);
		}
	}
}
