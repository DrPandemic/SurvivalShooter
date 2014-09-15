package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class LevelSelectionScreen extends Screen {
		public static var LevelCompletion:LevelCompletionData = new LevelCompletionData();
		private var levelArray:Array;
		private var levelMessages:Array;
		private static const START_X:Number=20;
		private static const START_Y:Number=150;
		private const LOCKED_ALPHA:Number = 0.5;
		private const UNLOCKED_ALPHA:Number = 1;
		
		private const DONE_LEVEL_FRAME:Number = 1;
		private const CURRENT_LEVEL_FRAME:Number = 3;
		private const LOCKED_LEVEL_FRAME:Number = 2;
		
		public function LevelSelectionScreen() {
			fillLevelMessages();
			levelArray=new Array();
			LevelCreation();
			PlaceIcons();
			
			backButton.addEventListener(MouseEvent.CLICK, backClick, false, 0, true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, backPress, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			levelMessage.text = getLevelMessage();
			stage.focus = stage;
		}
		private function PlaceIcons():void
		{
			var x_ = START_X;
			var y_ = START_Y;
			for each(var _icon:LevelSelectionIcon in levelArray)
			{
				_icon.x=x_;
				_icon.y=y_;
				
				x_+=(_icon.width*1.5);
				if(x_>=DocumentClass.SCREEN_W-_icon.width)
				{
					x_=START_X;
					y_+=_icon.height*1.5;
				}
				var locked:Boolean = LevelCompletion.isLocked(_icon.level);
				_icon.alpha = locked ? LOCKED_ALPHA : UNLOCKED_ALPHA; // hide locked levels, show unlocked ones
				_icon.locked = locked;
				
				// Give a frame to the icon depending on if it's the current level, an already done level or
				// a locked level.
				var frame:Number = locked ? LOCKED_LEVEL_FRAME :
					(LevelCompletion.isCurrent(_icon.level) ? CURRENT_LEVEL_FRAME : DONE_LEVEL_FRAME);
				_icon.gotoAndStop(frame);
				
				addChild(_icon);
			}

		}
		private function LevelCreation():void
		{
			levelArray.push(new LevelSelectionIcon("Pluto", 1));
			levelArray.push(new LevelSelectionIcon("Neptune", 2));
			levelArray.push(new LevelSelectionIcon("Uranus", 3));
			levelArray.push(new LevelSelectionIcon("Saturn", 4));
			levelArray.push(new LevelSelectionIcon("Jupiter", 5));
			levelArray.push(new LevelSelectionIcon("Mars", 6));
			levelArray.push(new LevelSelectionIcon("the Moon", 7));
			levelArray.push(new LevelSelectionIcon("Earth", 8));
			levelArray.push(new LevelSelectionIcon("Venus", 9));
			levelArray.push(new LevelSelectionIcon("Mercury", 10));
		}
		public override function destroy():void
		{
			backButton.removeEventListener(MouseEvent.CLICK, backClick);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, backPress);
			for each (var _icon:LevelSelectionIcon in levelArray)
			{
				_icon.destroy();
				if (contains(_icon)) removeChild(_icon);
			}
			removeChild(backButton);
		}
		private function backClick(e:MouseEvent):void
		{
			backButton.removeEventListener(MouseEvent.CLICK, backClick);
			backToMenu();
		}
		private function backPress(e:InputEvents):void
		{
			InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, backPress);
			backToMenu();
		}
		private function backToMenu():void
		{
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_MENU));
		}
		private function fillLevelMessages():void
		{
			levelMessages = new Array(
				"You'll die in the first level.",
				"Oh, how cute. Good luck with the next one.",
				"Meh, beginner's luck. You'll die now.",
				"Feeling so clever huh? Level 4 is impossible.",
				"I meant, level 5 is impossible.",
				"Really? Level 6 will stop you.",
				"You'll NEVER beat level 7.",
				"Level 8 is full of zombies. You'll die.",
				"Level 9 is the hardest of all.",
				"I lied. Level 10 is truly impossible. It really is.",
				"Ok, I admit. You are good at this game.");
		}
		private function getLevelMessage():String
		{
			var lvl:Number = LevelCompletion.getCurrentLevel();
			if (lvl <= 0) lvl = 1;
			if (lvl >= levelMessages.length) lvl = levelMessages.length;
			return levelMessages[lvl-1];
		}
	}
	
}
