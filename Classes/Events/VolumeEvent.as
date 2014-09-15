package  {
	import flash.events.Event;
	
	public class VolumeEvent extends Event {
		//basics to set the options menu
		public static const ASK:String = "Ask";
		public static const RESOND:String = "Respond";
		
		//Changing settings
		public static const CHANGE_SOUND:String = "ChangeSound";
		public static const CHANGE_SOUND_LEVEL:String = "ChangeSoundLevel";
		public static const CHANGE_MUSIC:String = "ChangeMusic";
		
		public var soundLevel:Number;
		public var sound:Boolean;
		public var music:Boolean;
		public function VolumeEvent(type:String) {
			super(type);
		}

	}
	
}
