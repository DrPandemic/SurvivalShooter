package  {
	
	import flash.display.MovieClip;
	
	
	public class LowerUITooltip extends MovieClip {
		
		
		public function LowerUITooltip() {
			// constructor code
		}
		
		public function setTooltip(info:String):void
		{
			theInfo.text = info;
		}
	}
	
}
