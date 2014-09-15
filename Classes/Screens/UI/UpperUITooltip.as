package  {
	
	import flash.display.MovieClip;
	
	
	public class UpperUITooltip extends MovieClip {
		public function UpperUITooltip() {
		}
		
		public function setTooltip(info:String):void
		{
			theInfo.text = info;
		}
	}
	
}
