package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	
	public class MainMenuScreen extends Screen {
		
		
		public function MainMenuScreen() {
			Mouse.show();
			playButton.addEventListener(MouseEvent.CLICK,onClickPlay,false,0,true);
			optionsButton.addEventListener(MouseEvent.CLICK,onClickOptions,false,0,true);
		}
		private function onClickPlay(e:MouseEvent):void
		{
			if(playButton.hasEventListener(MouseEvent.CLICK)) 
				playButton.removeEventListener(MouseEvent.CLICK,onClickPlay);
				
			if(optionsButton.hasEventListener(MouseEvent.CLICK)) 
				optionsButton.removeEventListener(MouseEvent.CLICK,onClickOptions);
				
				InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_SELECTION));
		}
		private function onClickOptions(e:MouseEvent):void
		{
			 InputEventCannon.mainInstance.dispatchEvent(new InputEvents(InputEvents.OPEN_OPTIONS));
			
		}

	}
	
}
