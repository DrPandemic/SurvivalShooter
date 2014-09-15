package  {
	
	import flash.display.MovieClip;
	
	
	public class TechMapResource extends MapResource {
		private static const MILLISECS_FOR_CAPTURE:Number = 7500;
		private static const MILLISECS_FOR_INCOME:Number = 2000;
		public function TechMapResource() {
			super(Inventory.TECH_RESOURCE, MILLISECS_FOR_CAPTURE, MILLISECS_FOR_INCOME);
		}
	}
	
}
