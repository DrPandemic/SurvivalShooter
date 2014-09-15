package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class DeathScreen extends Screen {
		
		
		public function DeathScreen() {
			mainMenuButton.addEventListener(MouseEvent.CLICK,onClickReturn,false,0,true);
			restartButton.addEventListener(MouseEvent.CLICK,onClickRestart,false,0,true);
		}
		public function onClickReturn(e:MouseEvent):void
		{
			mainMenuButton.removeEventListener(MouseEvent.CLICK, onClickReturn);
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_MENU));
		}
		public function onClickRestart(e:MouseEvent):void
		{
			mainMenuButton.removeEventListener(MouseEvent.CLICK, onClickRestart);
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.RESTART_GAME));
		}
		
		
	}
	
}
