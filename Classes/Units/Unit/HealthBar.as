package  {
	
	import flash.display.MovieClip;
	
	
	public class HealthBar extends MovieClip {
		
		public function HealthBar(friendly:Boolean) {
			progress.setIsFriendly(friendly);
		}
		
		public function setProgress(healthPercent:Number):void
		{
			progress.scaleX = healthPercent;
		}
	}
	
}
