package  {
	import flash.geom.Point;
	
	public class Path {
		private static const DISTANCE_TO_TILE_REQUIRED = 1;
		
		private var nodes:Array;
		private var useless:Boolean; // If we can walk in a straight line towards the target: the path is useless

		public function Path() {
			nodes = new Array();
			useless = false;
		}
		
		public function addNode(tile:Tile):void
		{
			nodes.push(tile);
		}
		
		// If we can just skip using the path
		public function pathIsNeeded():Boolean
		{
			return !useless;
		}

		public function getTargetNode(attackerPos:Point):Tile
		{
			if (nodes.length == 0) return null;
			
			var last:Tile = nodes[nodes.length-1];
			var next:Tile = last; // assume that we will target the last element
			// We got close enought to go towards the next element!
			if (Point.distance(new Point(last.x+Map.TILE_W/2, last.y+Map.TILE_H/2), attackerPos) <= DISTANCE_TO_TILE_REQUIRED)
			{
				nodes.pop(); // remove our current target
				if (nodes.length > 0) next = nodes[nodes.length-1]; // if we have a next element, aim towards it (update last element)
			}
			
			return next;
		}
		
		public function smooth_path(from:Point, target:WorldObject, map:Map):void
		{
			// if we can walk straight to our target, the path is useless.
			if (map.walkableToPos(from, new Point(target.x, target.y), Zombie.BODY_WIDTH))
			{
				useless = true;
				return;
			}
			if (nodes.length <= 1) return; // too small path to smooth!
			
			var checkPoint:Point = from;
			
			for (var i:Number = nodes.length - 1; i > 0; i--)
			{
				var currentPoint:Tile = nodes[i];
				if (map.walkableToTile(checkPoint, nodes[i-1], Zombie.BODY_WIDTH))
				{
					// Make a straight path between those points:
					nodes.splice(i, 1);
				}
				else
				{
					checkPoint = new Point(currentPoint.x+Map.TILE_H/2, currentPoint.y+Map.TILE_H/2);
				}
			}
			
			if (nodes.length > 2 && // more than one node (we actually have a path!)
				map.walkableToTile(from, nodes[nodes.length-2], Zombie.BODY_WIDTH)) // and we can walk from where we are to the next node
			{
				nodes.pop(); // remove the starting node
			}
		}
		
		public function length():Number
		{
			return nodes.length;
		}
	}
	
}
