package  {
	
	import flash.display.MovieClip;
	
	
	public class ResourceCaptureProgress extends MovieClip {
		public static const ZOMBIE_CAPTURED:Number = -1;
		public static const PLAYER_CAPTURED:Number = 1;
		public static const NEUTRAL_CAPTURED:Number = 0;
		
		public function ResourceCaptureProgress() {
			setProgress(NEUTRAL_CAPTURED);
		}
		
		// Shows the image based on the current progress of the capture
		// -1 = Zombie complete capture (contaminates other zombies)
		// 1 = Player complete capture (generates income)
		// 0 = Neutral resource (untouched)
		public function setProgress(progress:Number):void
		{
			if (progress < ZOMBIE_CAPTURED ||
				progress > PLAYER_CAPTURED)
				throw new Error("Resource capture progress is invalid! Must be between -1 and 1, see comments in file.");
				
			// We convert to a positive percentage (0 to 1)
			var progressPercent = (progress - ZOMBIE_CAPTURED) / (PLAYER_CAPTURED - ZOMBIE_CAPTURED);
			
			// And take the right frame
			gotoAndStop(Math.floor((totalFrames+1) * progressPercent));
		}
		
		public function isOwnedByPlayer():Boolean
		{
			return currentFrame == totalFrames;
		}
		
		public function isOwnedByZombie():Boolean
		{
			return currentFrame == 1;
		}
	}
	
}
