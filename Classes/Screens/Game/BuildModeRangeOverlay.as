package  {
	
	import flash.display.MovieClip;
	
	
	public class BuildModeRangeOverlay extends MovieClip {
		const VALID_FRAME:Number = 1;
		const INVALID_FRAME:Number = 2;
		
		public function BuildModeRangeOverlay() {
			// constructor code
		}
		
		public function setTileIsValid(isValid:Boolean):void
		{
			gotoAndStop(isValid ? VALID_FRAME : INVALID_FRAME);
		}
	}
	
}
