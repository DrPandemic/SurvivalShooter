package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class OptionsMenuScreen extends MovieClip {
		var confirmBox:ConfirmMenuScreen;
		
		public function OptionsMenuScreen(canQuit:Boolean)  {
			backButton.addEventListener(MouseEvent.CLICK,onClickBack,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, onClickBack,false,0,true);
			
			InputEventCannon.mainInstance.openOptions();
			
			quitButton.visible = canQuit;
			quitButton.addEventListener(MouseEvent.CLICK,onClickQuit,false,0,true);
			
			//settings
			musicButton.isMusic=true;			
		}

		private function onClickQuit(e:Event):void
		{
			confirmBox = new ConfirmMenuScreen();
			addChild(confirmBox);
			confirmBox.addEventListener(ConfirmEvent.YES, onYesQuit,false,0,true);
			confirmBox.addEventListener(ConfirmEvent.NO, onNoQuit,false,0,true);
		}
		
		private function onYesQuit(e:Event):void
		{
			removeConfirmBox();
			
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_SELECTION));
		}
		
		private function onNoQuit(e:Event):void
		{
			removeConfirmBox();
		}
		
		private function removeConfirmBox():void
		{
			confirmBox.removeEventListener(ConfirmEvent.YES, onYesQuit);
			confirmBox.removeEventListener(ConfirmEvent.NO, onNoQuit);
			removeChild(confirmBox);
			if (stage != null) stage.focus = stage;
		}
		
		private function onClickBack(e:Event):void
		{
			InputEventCannon.mainInstance.closeOptions();
			
			backButton.removeEventListener(MouseEvent.CLICK,onClickBack);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, onClickBack);
			
			dispatchEvent(new DocumentClassEvent(InputEvents.OPEN_OPTIONS));
		}
	}
	
}
