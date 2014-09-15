package  {
	
	import flash.display.MovieClip;
	
	
	public class BaseMapResource extends MapResource {
		private static const MILLISECS_FOR_CAPTURE:Number = 5000;
		private static const MILLISECS_FOR_INCOME:Number = 1000;
		public function BaseMapResource() {
			super(Inventory.BASE_RESOURCE, MILLISECS_FOR_CAPTURE, MILLISECS_FOR_INCOME);
		}
	}
	
}
