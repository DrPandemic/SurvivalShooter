package  {
	
	import flash.display.MovieClip;
	
	
	public class ProgressMapResource extends MapResource {
		private static const MILLISECS_FOR_CAPTURE:Number = 10000;
		private static const MILLISECS_FOR_INCOME:Number = 3000;
		public function ProgressMapResource(playerOwned:Boolean = true) {
			super(Inventory.PROGRESS_RESOURCE, MILLISECS_FOR_CAPTURE, MILLISECS_FOR_INCOME);
			if (playerOwned) setProgress(ResourceCaptureProgress.PLAYER_CAPTURED);
		}
	}
	
}
