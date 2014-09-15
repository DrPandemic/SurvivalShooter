package  {
	import flash.geom.Point;
	
	public class Camera {
		public var x:Number;
		public var y:Number;
		
		private var oldX:Number = -1;
		private var oldY:Number = -1;

		public function Camera() {
			x = 0;
			y = 0;
		}

		// Call this every tick.
		// Also prevents the camera from going off the map.
		public function placeMapForCamera(map:Map):void
		{
			x = Math.max(0, // keep it positive
						 Math.min(x, map.getTotalTilesWidth() - DocumentClass.SCREEN_W)); // keep it smaller than the map
			y = Math.max(0, // keep it positive
						 Math.min(y, map.getTotalTilesHeight() - DocumentClass.SCREEN_H)); // keep it smaller than the map
			y -= GameUI.MAP_START_Y;
			
			oldX = (int)(x);
			oldY = (int)(y);
			
			x = (int)(x);
			y = (int)(y);
			
			map.x = -x;
			map.y = -y;
			
			if (oldX != x || oldY != y) map.hideTilesNotOnScreen();
		}
		
		public function isTileInCameraSight(map:Map, x:Number, y:Number):Boolean
		{
			return map.x + x + Map.TILE_W >= 0 && // not out on the left
				map.x + x <= DocumentClass.SCREEN_W && // neither on the right
				map.y - GameUI.MAP_START_Y + y + Map.TILE_H >= 0 && // nor the top
				map.y - GameUI.MAP_START_Y + y <= DocumentClass.SCREEN_H; // nor the bottom
		}
		
		// From world (e.g. player position) to screen (on the screen monitor)
		public function worldToScreenCoords(worldPos:Point):Point
		{
			return new Point(worldPos.x - x, worldPos.y - y);
		}
		
		// From screen (e.g. mouse position on the screen monitor) to world (the aim of the player relative to him)
		public function screenToWorldCoords(screenPos:Point):Point
		{
			return new Point(x + screenPos.x, y + screenPos.y);
		}
		
		// Call this every tick
		public function followPlayer(player:Player):void
		{
			x = player.x - DocumentClass.SCREEN_W / 2;
			y = player.y - DocumentClass.SCREEN_H / 2;
		}
	}
	
}
