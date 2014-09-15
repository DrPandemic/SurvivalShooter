package  {
	
	public class ZombieSpawner {
		private var _map:Map;
		private var _millisecondsSinceLastSpawn:Number;
		private var _millisecondsForNextSpawn:Number;
		private var _spawnTimers:LevelSpawnTimers;

		public function ZombieSpawner(map:Map, level:Number) {
			_map = map;
			_millisecondsSinceLastSpawn = 0;
			_spawnTimers = new LevelSpawnTimers(level);
		}

		public function shouldSpawn():Boolean
		{
			_millisecondsSinceLastSpawn += GameScreen.MILLISECS_PER_FRAME;
			if (_millisecondsSinceLastSpawn > _spawnTimers.millisecondsForSpawn())
			{
				_millisecondsSinceLastSpawn = 0;
				_spawnTimers.nextSpawnTime();
				
				return true;
			}
			
			return false;
		}
		
		public function getSpawnTile():Tile
		{
			var emptyTiles:Array = _map.getEmptyTiles();
			var index:Number = Math.floor(Math.random() * emptyTiles.length);
			if (index >= emptyTiles.length) index = emptyTiles.length - 1;
			
			return emptyTiles[index];
		}
	}
	
}
