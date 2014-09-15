package  {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	
	
	public class InputEventCannon extends MovieClip {
		public static const UPDATE:String = "Update";
		
		private static const PRESS_DICTIONARY:Number = 0;
		private static const RELEASE_DICTIONARY:Number = 1;
		private static const WHEEL_DICTIONARY:Number = 2;
		
		private static const WHEEL_UP:Number = 1;
		private static const WHEEL_DOWN:Number = 0;
		
		private static var dictionaryPress:Dictionary;
		private static var dictionaryRelease:Dictionary;
		private static var dictionaryWheel:Dictionary;
		
		public static var mainInstance:InputEventCannon;
		
		private var isPaused:Boolean;
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var isMouseShow:Boolean;
		
		private var isMouseOnShop:Boolean;
		
		private var keyObject:KeyObject;

		public function InputEventCannon() {
			if(mainInstance==null)
			{
				mainInstance=this;
				
				dictionaryPress=new Dictionary();
				dictionaryRelease=new Dictionary();
				dictionaryWheel=new Dictionary();
				
				createDefaultKeyDictionary();
				
				isPaused = false;
				
				isMouseOnShop = false;
				
				addEventListener( Event.ADDED_TO_STAGE, onAddToStage,false,0,true );
			}
		}
		public static function addKeyForIn(eventKey:String,keyboardEvent:uint, _dictionary:Number):void
		{
			
			if(_dictionary==PRESS_DICTIONARY)
			{
				dictionaryPress[keyboardEvent]=eventKey;
			}
			else if(_dictionary==RELEASE_DICTIONARY)
			{
				dictionaryRelease[keyboardEvent]=eventKey;
			}
			else if(_dictionary==WHEEL_DICTIONARY)
			{
				dictionaryWheel[keyboardEvent]=eventKey;

			}
		}
		private function createDefaultKeyDictionary():void
		{
			addKeyForIn(InputEvents.PLAYER_DOWN_PRESS,Keyboard.DOWN,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_DOWN_PRESS,Keyboard.S,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_UP_PRESS,Keyboard.UP,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_UP_PRESS,Keyboard.W,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_RIGHT_PRESS,Keyboard.RIGHT,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_RIGHT_PRESS,Keyboard.D,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_LEFT_PRESS,Keyboard.LEFT,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_LEFT_PRESS,Keyboard.A,PRESS_DICTIONARY);
			
			
			addKeyForIn(InputEvents.PLAYER_DOWN_RELEASE,Keyboard.DOWN,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_DOWN_RELEASE,Keyboard.S,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_UP_RELEASE,Keyboard.UP,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_UP_RELEASE,Keyboard.W,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_RIGHT_RELEASE,Keyboard.RIGHT,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_RIGHT_RELEASE,Keyboard.D,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_LEFT_RELEASE,Keyboard.LEFT,RELEASE_DICTIONARY);
			addKeyForIn(InputEvents.PLAYER_LEFT_RELEASE,Keyboard.A,RELEASE_DICTIONARY);
			
			
			addKeyForIn(InputEvents.OPEN_OPTIONS,Keyboard.ESCAPE,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.OPEN_SHOP,Keyboard.E,PRESS_DICTIONARY);
			
			
			addKeyForIn(InputEvents.ITEM_CHOICE_UP, WHEEL_UP, WHEEL_DICTIONARY);
			addKeyForIn(InputEvents.ITEM_CHOICE_DOWN, WHEEL_DOWN, WHEEL_DICTIONARY);
			
			
			addKeyForIn(InputEvents.WEAPON_1,Keyboard.NUMBER_1,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.WEAPON_2,Keyboard.NUMBER_2,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.WEAPON_3,Keyboard.NUMBER_3,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.WEAPON_4,Keyboard.NUMBER_4,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.WEAPON_5,Keyboard.NUMBER_5,PRESS_DICTIONARY);
			addKeyForIn(InputEvents.WEAPON_6,Keyboard.NUMBER_6,PRESS_DICTIONARY);
			
			addKeyForIn(InputEvents.PLAYER_TOGGLE_BUILD_MODE, Keyboard.Q, RELEASE_DICTIONARY);
		}
		public function onAddToStage(e:Event):void
		{
			//keys
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress,false,0,true );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease,false,0,true );	
			//mouse wheel
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheelEvent,false,0,true);
			//mouse
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMoved,false,0,true);
			//out focus
			stage.addEventListener(Event.DEACTIVATE, onOutFocus,false,0,true);
			stage.addEventListener(Event.ACTIVATE, onFocus,false,0,true);
			
			
			keyObject = new KeyObject(stage);
		}
		private function onMouseWheelEvent(e:MouseEvent):void
		{
			if(e.delta>0)
			{
				if(dictionaryWheel[WHEEL_DOWN]!=null)
				{
					dispatchEvent(new InputEvents(dictionaryWheel[WHEEL_DOWN],e.delta));
				}
				
			}
			else if(e.delta<0)
			{
				if(dictionaryWheel[WHEEL_UP]!=null)
				{
					dispatchEvent(new InputEvents(dictionaryWheel[WHEEL_UP],e.delta));
				}
			}


		}
		private function onKeyPress(e:KeyboardEvent):void
		{
			//check if the dictionary has something for this particuliar key
			if(dictionaryPress[e.keyCode]!=null)
			{
				dispatchEvent(new InputEvents(dictionaryPress[e.keyCode]));
			}
		}
		private function onKeyRelease(e:KeyboardEvent):void
		{
			//check if the dictionary has something for this particuliar key
			if(dictionaryRelease[e.keyCode]!=null)
			{
				dispatchEvent(new InputEvents(dictionaryRelease[e.keyCode]));
			}
		}

	public function isPlayerMoveLeft():Boolean
		{
			return keyObject.isDown(Keyboard.A) ||
				keyObject.isDown(Keyboard.LEFT);
		}
		public function isPlayerMoveRight():Boolean
		{
			return keyObject.isDown(Keyboard.D) ||
				keyObject.isDown(Keyboard.RIGHT);
		}
		public function isPlayerMoveUp():Boolean
		{
			return keyObject.isDown(Keyboard.W) ||
				keyObject.isDown(Keyboard.UP);
		}
		public function isPlayerMoveDown():Boolean
		{
			return keyObject.isDown(Keyboard.S) ||
				keyObject.isDown(Keyboard.DOWN);
		}
		public function wantsToKeepBuilding():Boolean
		{
			return keyObject.isDown(Keyboard.SHIFT);
		}
		public function openOptions():void
		{
			pause();
		}
		public function closeOptions():void
		{
			unpause();
		}
		public function pause():void
		{
			changePause(true);
		}
		public function unpause():void
		{
			changePause(false);
		}
		
		public function get isPause():Boolean
		{
			return isPaused;
		}
		private function onMouseMoved(e:MouseEvent):void
		{
			_mouseX=e.stageX;
			_mouseY=e.stageY;
			
		}
		private function onOutFocus(e:Event):void
		{
			dispatchEvent(new InputEvents(InputEvents.GAME_LOST_FOCUS));
		}
		private function onFocus(e:Event):void
		{
			//changePause(false);
		}
		private function changePause(_isPaused:Boolean):void
		{
			if(isPaused!=_isPaused)
			{
				isPaused=_isPaused;
				if(isPaused) dispatchEvent(new InputEvents(InputEvents.PAUSE_GAME)); 
				else dispatchEvent(new InputEvents(InputEvents.RESUME_GAME)); 
			}
		}
		
		public function setMouseOnShop(onShop:Boolean):void
		{
			isMouseOnShop = onShop;
		}
		
		public function isFocusOnShop():Boolean
		{
			return isMouseOnShop;
		}
	}
	
}
