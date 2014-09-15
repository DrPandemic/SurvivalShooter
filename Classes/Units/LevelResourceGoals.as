package  {
	
	public class LevelResourceGoals {

		private var researchResourceGoals:Array;
		private var killResourceGoals:Array;

		public function LevelResourceGoals() {
			fillGoals();
		}
		
		private function fillGoals():void
		{
			// Every number represents the amount of research resource required to pass the given level (where
			// levels are represented as indices. So, level 1 = index 0, level 2 = index 1, etc.)
			researchResourceGoals = new Array(
				40,  // level 1
				100,  // level 2
				50, // level 3
				125, // level 4
				175, // level 5
				200, // level 6
				225, // level 7
				100, // level 8
				175, // level 9
				100  // level 10
				);
				
			// Every number represents the amount of kills required to pass the given level (where
			// levels are represented as indices. So, level 1 = index 0, level 2 = index 1, etc.)
			killResourceGoals = new Array(
				5,  // level 1
				10,  // level 2
				10, // level 3
				20, // level 4
				30, // level 5
				30, // level 6
				30, // level 7
				50, // level 8
				30, // level 9
				50  // level 10
				);
		}
		
		public function getResourcesForWin(currentLevel:Number):Number
		{
			return getGoalForArray(currentLevel, researchResourceGoals);
		}
		
		public function getKillsForWin(currentLevel:Number):Number
		{
			return getGoalForArray(currentLevel, killResourceGoals);
		}
		
		private function getGoalForArray(currentLevel:Number, array:Array):Number
		{
			// Get a valid level
			currentLevel = MathHelper.clamp(currentLevel, 1, array.length);
			// return the resource amount based on the level index
			return array[currentLevel - 1];
		}
		
		public function hasWon(inventory:Inventory, level:Number):Boolean
		{
			return inventory.getResourceQuantity(Inventory.PROGRESS_RESOURCE) >= getResourcesForWin(level) &&
				inventory.getResourceQuantity(Inventory.KILL_RESOURCE) >= getKillsForWin(level);
		}
	}
	
}
