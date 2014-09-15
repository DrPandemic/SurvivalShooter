package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LevelWinScreen extends MovieClip {
		private var _level:Number;
		public function LevelWinScreen(level:Number) {
			_level = level;
			
			_level++; // set the next level so that if we want to play the next level, it restarts with the next one.
			LevelSelectionScreen.LevelCompletion.unlock(_level); // unlock the next level.
			
			nextLevelButton.addEventListener(MouseEvent.CLICK, onNextLevel, false, 0, true);
			mainMenuButton.addEventListener(MouseEvent.CLICK, onMainMenu, false, 0, true);
		}
		
		private function onNextLevel(e:MouseEvent) {
			nextLevelButton.removeEventListener(MouseEvent.CLICK, onNextLevel);
			
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(
				DocumentClassEvent.LAUNCH_GAME, _level));
		}
		
		private function onMainMenu(e:MouseEvent) {
			mainMenuButton.removeEventListener(MouseEvent.CLICK, onMainMenu);
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_SELECTION));
		}
	}
	
}
