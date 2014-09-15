package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class ProductivityBoosterMapObject extends LivingWorldObject {
		public static const PRODUCTIVITY_BOOST:Number = 0.1;
		public static const MAX_DISTANCE:Number = Map.TILE_H * 3;
		
		public function ProductivityBoosterMapObject() {
			super(true, false, 15);
		}
		
		public override function update(player:Player, zombies:Array, map:Map):void
		{
			var resources:Array = map.getResourceObjects();
			for each(var resource:MapResource in resources)
			{
				var diffX:Number = resource.x - x;
				var diffY:Number = resource.y - y;
				var distSquared:Number = diffX * diffX + diffY * diffY;
				
				if (distSquared <= MAX_DISTANCE * MAX_DISTANCE)
					resource.productivityModificator += PRODUCTIVITY_BOOST;
			}
		}
	}
	
}
