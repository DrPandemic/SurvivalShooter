package  {
	import flash.events.Event;
	
	public class SoundEvent extends Event {
		
		//Commands
		public static const PLAY_MUSIC:String = "PlayMusic";
		public static const STOP_MUSIC:String = "StopMusic";		
		public static const PLAY_SOUND:String = "PlaySound";		
		
		//Sounds name
		//Music
		public static const M_GAME:String = "GameMusic";		
		//Sounds
		public static const S_KNIFFE_ATTACK:String = "KniffeAttackSound";

		public var sound_:String;
		public function SoundEvent(type:String,sound:String=null) {
			super(type);
			sound_=sound;
		}

	}
	
}
