package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class TutorialMenuScreen extends Screen {
		
		public function TutorialMenuScreen() {
			stop();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false,0,true);
		}
		public function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.addEventListener(MouseEvent.CLICK, onClick, false,0,true);
			skipButton.addEventListener(MouseEvent.CLICK, onSkipClick, false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, onSkipPress, false,0,true);
			stage.focus = stage;
		}
		public override function destroy():void
		{
			if (stage != null) stage.removeEventListener(MouseEvent.CLICK, onClick);
			skipButton.removeEventListener(MouseEvent.CLICK, onSkipClick);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, onSkipPress);
		}
		private function onSkipClick(e:MouseEvent):void
		{
			skipTutorial();
		}
		private function onSkipPress(e:InputEvents):void
		{
			skipTutorial();
		}
		private function skipTutorial():void
		{
			InputEventCannon.mainInstance.dispatchEvent(
					new DocumentClassEvent(DocumentClassEvent.LAUNCH_GAME));
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (currentFrame + 1 > totalFrames)
			{
				skipTutorial(); // done with the tutorial, quit.
			}
			gotoAndStop(currentFrame+1);
		}
	}
	
}
