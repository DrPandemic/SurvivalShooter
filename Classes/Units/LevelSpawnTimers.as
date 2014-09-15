package  {
	
	public class LevelSpawnTimers {
		private var levels:Array;
		private var curLevelIndex:Number;

		public function LevelSpawnTimers(level:Number) {
			curLevelIndex = level;
			
			levels = new Array();
			levels[0] = level1();
			levels[1] = level2();
			levels[2] = level3();
			levels[3] = level4();
			levels[4] = level5();
			levels[5] = level6();
			levels[6] = level7();
			levels[7] = level8();
			levels[8] = level9();
			levels[9] = level10();
			
			// Too big level? error.
			if (curLevelIndex > levels.length)
				throw new Error("Level is not supported while creating the spawn timers (LevelSpawnTimers)");
			
			--curLevelIndex; // we want an index, instead of the level number, so minus 1.
			
			if (curLevelIndex < 0) curLevelIndex = 0; // keep a valid index
		}
		
		public function millisecondsForSpawn():Number
		{
			const MILLISECS_PER_SEC:Number = 1000;
			// Get the seconds to wait for the current level, at the first index
			// since we're working with "first element == our next element"
			return levels[curLevelIndex][0] * MILLISECS_PER_SEC;
		}
		
		public function nextSpawnTime():void
		{
			// do we still have a spawn time to switch to? if not, just keep our last value
			// forever
			if (levels[curLevelIndex].length > 1)
				levels[curLevelIndex].splice(0, 1);
		}

		// All the arrays below represent how many seconds the player has to wait for the next zombie to spawn.
		// Once it reached the end, the last value of the array is repeated forever.
		private function level1():Array
		{
			return new Array(
				45, 15, 15, 25, 5, 15, 15, 15, 15, 20, 20, 20, 10, 10, 10, 15, 15, 15, 20,
				10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 5, 5, 3, 3, 3, 3, 3, 3, 10);
		}
		
		private function level2():Array
		{
			return new Array(
				30, 15, 15, 10, 5, 10, 10, 10, 10, 15, 15, 15, 10, 15, 15, 20, 25, 15, 20,
				10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 5, 5, 3, 3, 3, 3, 3, 3, 8);
		}
		
		private function level3():Array
		{
			return new Array(
				30, 10, 10, 15, 5, 20, 20, 15, 20, 20, 20, 20, 10, 10, 10, 10, 10, 5, 5,
				10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 5, 5, 3, 3, 3, 3, 3, 3, 7);
		}
		
		private function level4():Array
		{
			return new Array(
				10, 10);
		}
		
		private function level5():Array
		{
			return new Array(
				8, 8);
		}
		
		private function level6():Array
		{
			return new Array(
				5, 5, 5, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 5, 5,
				20, 30, 30, 5, 5, 5, 3, 3, 0, 0, 0, 0, 10, 10, 5, 5, 5, 5, 3, 3, 6);
		}
		
		private function level7():Array
		{
			return new Array(
				0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 3, 3, 3, 3, 3, 5, 5, 5, 5, 10, 10, 10, 10,
				5, 5, 0, 0, 5, 0, 0, 5, 0, 0, 5, 0, 0, 10, 5, 5, 5, 5, 5, 3, 3, 3, 5);
		}
		
		private function level8():Array
		{
			return new Array(
				3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4);
		}
		
		private function level9():Array
		{
			return new Array(
				0, 0, 0, 5, 5, 5, 5, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0,
				5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 3, 3, 3, 2, 2, 2, 3);
		}
		
		private function level10():Array
		{
			return new Array(
				5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15, 1, 1, 1, 1, 1, 15, 0);
		}
	}
	
}
