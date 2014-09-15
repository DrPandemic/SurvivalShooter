package  {
	import flash.events.Event;
	
	public class InputEvents extends Event {
		public static const PLAYER_UP_PRESS:String = "PlayerUpStart";
		public static const PLAYER_UP_RELEASE:String = "PlayerUpFinish";
		public static const PLAYER_DOWN_PRESS:String = "PlayerDownStart";
		public static const PLAYER_DOWN_RELEASE:String = "PlayerDownFinish";
		public static const PLAYER_LEFT_PRESS:String = "PlayerLeftStart";
		public static const PLAYER_LEFT_RELEASE:String = "PlayerLeftFinish";
		public static const PLAYER_RIGHT_PRESS:String = "PlayerRightStart";
		public static const PLAYER_RIGHT_RELEASE:String = "PlayerRightFinish";
		
		public static const OPEN_OPTIONS:String = "OpenOptions";
		
		public static const OPEN_SHOP:String = "OpenShop";
		
		public static const GAME_LOST_FOCUS:String = "GameLostFocus";
		
		public static const ITEM_CHOICE_UP:String = "ItemChoiceUp";
		public static const ITEM_CHOICE_DOWN:String = "ItemChoiceDown";
		
		public static const WEAPON_1:String = "Weapon1";
		public static const WEAPON_2:String = "Weapon2";
		public static const WEAPON_3:String = "Weapon3";
		public static const WEAPON_4:String = "Weapon4";
		public static const WEAPON_5:String = "Weapon5";
		public static const WEAPON_6:String = "Weapon6";
		
		public static const PLAYER_TOGGLE_BUILD_MODE:String = "PlayerToggleBuild";
		
		public static const PAUSE_GAME:String = "PauseGame";
		public static const RESUME_GAME:String = "ResumeGame";

		public var wheelDelta:Number;
		
		public function InputEvents(type:String,_delta:Number=0) {
			wheelDelta = _delta;
			super(type);
		}


	}
	
}
