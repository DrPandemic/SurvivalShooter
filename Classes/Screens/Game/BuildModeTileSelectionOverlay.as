package  {
	
	import flash.display.MovieClip;
	
	
	public class BuildModeTileSelectionOverlay extends MovieClip {
		private static const FRAME_FOR_VALID_TILE:Number = 1;
		private static const FRAME_FOR_INVALID_TILE:Number = 2;
		private static const ALPHA:Number = 0.5;
		
		public var tile:Tile;
		private var validTilePos:Boolean;
		
		public function BuildModeTileSelectionOverlay() {
			setTileIsValid(false);
			alpha = ALPHA;
		}
		
		public function setTileIsValid(isValid:Boolean):void
		{
			validTilePos = isValid;
			gotoAndStop(isValid ? FRAME_FOR_VALID_TILE : FRAME_FOR_INVALID_TILE);
		}
		
		public function get ValidTile():Boolean
		{
			return validTilePos;
		}
	}
	
}
