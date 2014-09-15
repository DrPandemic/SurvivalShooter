package  {
	import flash.events.Event;
	
	public class MusicBlaster {
		
		private var soundLevel_:Number;
		private var musicOn_:Boolean;
		private var soundOn_:Boolean;
		
		public function MusicBlaster() {
			musicOn_=true;
			soundOn_=true;
			soundLevel_=10;
			
			
			InputEventCannon.mainInstance.addEventListener(SoundEvent.PLAY_MUSIC, onPlayMusic,false,0,true);
			//to answer when the options screen ask for the saved settings
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.ASK, onAskSettings,false,0,true);
			//to save settings
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.CHANGE_MUSIC, onChangeMusic,false,0,true);
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.CHANGE_SOUND, onChangeSound,false,0,true);
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.CHANGE_SOUND_LEVEL, onChangeSoundLevel,false,0,true);
		}
		private function onPlayMusic(e:SoundEvent):void
		{
			
		}
		private function onAskSettings(e:Event):void
		{
			var volumeSettings:VolumeEvent = new VolumeEvent(VolumeEvent.RESOND);
			volumeSettings.soundLevel=soundLevel_;
			volumeSettings.music=musicOn_;
			volumeSettings.sound=soundOn_;
			InputEventCannon.mainInstance.dispatchEvent(volumeSettings);
		}
		private function onChangeMusic(e:VolumeEvent):void
		{
			musicOn_=e.music;

		}
		private function onChangeSound(e:VolumeEvent):void
		{
			soundOn_=e.sound;
		}
		private function onChangeSoundLevel(e:VolumeEvent):void
		{
			
			soundLevel_=e.soundLevel;
		}
	}
}
