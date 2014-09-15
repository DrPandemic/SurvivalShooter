package  {
	import flash.events.Event;
	
	public class DocumentClassEvent extends Event {
		public static const START_MENU:String = "StartMenu";
		public static const START_GAME:String = "StartGame";
		
		public static const LAUNCH_GAME:String = "Game";
		public static const LAUNCH_TUTORIAL:String = "Tutorial";
		public static const LAUNCH_MENU:String = "Menu";
		
		public static const LAUNCH_SELECTION:String = "LevelSelection";
		
		public static const RESTART_GAME:String = "Restart";
		
		public static const SHOW_NORMAL_MOUSE:String = "NormalMouse";
		public static const SHOW_AIM:String = "AimMouse";
		public var level:Number;

		public function DocumentClassEvent(type:String,level:Number=1) {
			this.level=level;
			super(type);
		}

	}
	
}
