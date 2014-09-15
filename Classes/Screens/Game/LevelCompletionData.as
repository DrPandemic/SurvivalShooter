package  {
	
	public class LevelCompletionData {
		private const START_LEVEL:Number = 11;
		private var lastUnlockedLevel:Number;

		public function LevelCompletionData() {
			//TODO: load the current level from the website?
			lastUnlockedLevel = START_LEVEL;
		}
			
		public function isLocked(level:Number):Boolean
		{
			return level > lastUnlockedLevel;
		}
		
		public function isCurrent(level:Number):Boolean
		{
			return level == lastUnlockedLevel;
		}
		
		public function unlock(level:Number):void
		{
			if (level >= lastUnlockedLevel)
				lastUnlockedLevel = level;
		}
		
		public function getCurrentLevel():Number
		{
			return lastUnlockedLevel;
		}
	}
	
}
