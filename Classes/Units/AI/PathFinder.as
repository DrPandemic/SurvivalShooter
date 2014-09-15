package  {
	import flash.utils.Dictionary;
	
	public class PathFinder {
		
		
		private var _map:Map;

		public function PathFinder(map:Map) {
			_map = map;
		}

		public function GetPath(startTile:Tile, endTile:Tile):Path
		{
			var closedList:Array = new Array();
			
			var openList:Array = new Array();
			openList.push(startTile);
			
			var came_from:Dictionary = new Dictionary();
			
			var g_score:Dictionary = new Dictionary();
			var f_score:Dictionary = new Dictionary();
			
			g_score[startTile] = 0;
			f_score[startTile] = g_score[startTile] + heuristic_cost_estimate(startTile, endTile);
			
			while (openList.length > 0)
			{
				var current:Tile = tileWithLowestFValue(openList, f_score);
				
				if (current.x == endTile.x &&
					current.y == endTile.y) return reconstruct_path(came_from, endTile);
				
				openList.splice(openList.indexOf(current), 1);
				closedList.push(current);
				for each (var neighbor:Tile in _map.getNeighbors(current))
				{
					if (closedList.indexOf(neighbor) >= 0 || 
						neighbor != endTile && !_map.isEmptyTile(neighbor) ||
						came_from[current] == neighbor) continue;
					var tentative_g_score:Number = g_score[current] + dist_between(current, neighbor);
					
					if (openList.indexOf(neighbor) < 0 || tentative_g_score < g_score[neighbor])
					{
						if (openList.indexOf(neighbor) < 0)
							openList.push(neighbor);
						came_from[neighbor] = current;
						g_score[neighbor] = tentative_g_score;
						f_score[neighbor] = tentative_g_score + heuristic_cost_estimate(neighbor, endTile);
					}
					
				}
			}
			
			return null;
		}
		
		private function dist_between(current:Tile, neighbor:Tile):Number
		{
			return heuristic_cost_estimate(current, neighbor);
		}
		
		private function reconstruct_path(camefrom:Dictionary, goal:Tile):Path
		{
			var p:Path = new Path();
			var current:Tile = goal;
			while (camefrom[current] != null)
			{
				p.addNode(current);
				current = camefrom[current]; 
			}
			p.addNode(current);
			return p;
		}
		
		private function tileWithLowestFValue(openList:Array, fscores:Dictionary):Tile
		{
			var lowest:Number = Number.MAX_VALUE;
			var lowestTile:Tile = null;
			for each (var tile:Tile in openList)
			{
				if (fscores[tile] < lowest)
				{
					lowest = fscores[tile];
					lowestTile = tile;
				}
			}
			return lowestTile;
		}
		
		private function heuristic_cost_estimate(s:Tile, e:Tile):Number
		{
			// Manhattan distance
			return Math.abs((s.y - e.y)/Map.TILE_H) + 
				Math.abs((s.x - e.x)/Map.TILE_W);
		}
	}
	
}
