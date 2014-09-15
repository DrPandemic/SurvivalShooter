package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class ConfirmMenuScreen extends MovieClip {
		
		
		public function ConfirmMenuScreen() {
			yesButton.addEventListener(MouseEvent.CLICK, onYesClick, false, 0, true);
			noButton.addEventListener(MouseEvent.CLICK, onNoClick, false, 0, true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, onNoClick, false, 0, true);
		}
		
		public function onYesClick(e:Event):void
		{
			dispatchEvent(new ConfirmEvent(ConfirmEvent.YES));
		}
		
		public function onNoClick(e:Event):void
		{
			dispatchEvent(new ConfirmEvent(ConfirmEvent.NO));
		}
	}
	
}
