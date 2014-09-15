package  {
	
	import flash.display.MovieClip;
	
	
	public class HealthBarValue extends MovieClip {
		private const ENEMY_FRAME:Number = 1;
		private const FRIENDLY_FRAME:Number = 2;
		
		public function HealthBarValue() {
		}
		
		public function setIsFriendly(friendly:Boolean):void
		{
			gotoAndStop(friendly ? FRIENDLY_FRAME : ENEMY_FRAME);
		}
	}
	
}
