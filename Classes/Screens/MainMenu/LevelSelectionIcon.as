package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class LevelSelectionIcon extends MovieClip {
		
		public var levelNameArea:LevelSelectionIconTextArea;
		public var level:Number;
		public var locked:Boolean;
		
		public function LevelSelectionIcon(levelName:String, theLevel:Number) 
		{
			locked = true;
			level=theLevel;
			
			buttonMode=true;
			mouseChildren = false;
			doubleClickEnabled = false;
			addEventListener(MouseEvent.CLICK, onClick,false,0,true);
			
		
			levelNameArea=new LevelSelectionIconTextArea();
			levelNameArea.text.text=levelName;
			addChild(levelNameArea);	
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			levelNumber.text = level.toString();
		}
		public function destroy():void
		{
			if (contains(levelNameArea)) removeChild(levelNameArea);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		public function onClick(e:MouseEvent):void
		{
			if (!locked)
			{
				// For a tutorial menu at the start:
				// use this: if (level == 1)
				// InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_TUTORIAL, level));
				
				if (level > 0)
					InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_GAME,level));
				else // invalid level
					throw new Error("Invalid level.");
			}
		}
	}
}
