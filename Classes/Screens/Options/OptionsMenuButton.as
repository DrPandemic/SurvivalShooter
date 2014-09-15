package  {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;	
	import flash.events.Event;
	
	public class OptionsMenuButton extends MovieClip {
		
		//You have to do an invisible layer to have the good over effect
		
		//to do : aller chercher son propre state a l'init
		
		private var usedIcon_:MovieClip;
		private var usedIconMouseOver_:MovieClip;
		private var currentIcon_:MovieClip;
		
		//If  the setting is on or off
		private var isOn_:Boolean;
		
		private var isDown_:Boolean = false;
		
		public var isMusic:Boolean = false;
		
		public var finishedInit:Boolean = false;
		
		public function OptionsMenuButton(isOn:Boolean=true) {
			
			isOn_=isOn;
			
			buttonMode=true;
			mouseChildren = false;
			doubleClickEnabled = false;
			addEventListener(MouseEvent.MOUSE_DOWN, onDown,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP, onUp,false,0,true);
			addEventListener(MouseEvent.MOUSE_OVER, onOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, onOut,false,0,true);
			addEventListener(MouseEvent.CLICK, onClick,false,0,true);
			
			
			if(isOn)
			{
				usedIcon_ =  new OptionsMenuButtonOn();
				usedIconMouseOver_ =  new OptionsMenuButtonOnOver();
			}
			else
			{
				usedIcon_ =  new OptionsMenuButtonOff();
				usedIconMouseOver_ =  new OptionsMenuButtonOffOver();
			}
						
			currentIcon_=usedIcon_;
			
			addChild(currentIcon_);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,false,0,true);			
		}
		private function onAddedToStage(e:Event):void
		{
			//To receive the saved settings
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.RESOND,onRespondVolumeSettings,false,0,true);
			InputEventCannon.mainInstance.dispatchEvent(new VolumeEvent(VolumeEvent.ASK));					
		}
		private function onRespondVolumeSettings(e:VolumeEvent):void
		{
			InputEventCannon.mainInstance.removeEventListener(VolumeEvent.RESOND,onRespondVolumeSettings);
			if(isMusic)
				setStyle(e.music);
			else
				setStyle(e.sound);
		}
		private function onDown(e:MouseEvent):void
		{
			removeChild(currentIcon_);
			currentIcon_=usedIcon_;
			addChild(currentIcon_);				
		}
		private function onUp(e:MouseEvent):void
		{
			removeChild(currentIcon_);
			currentIcon_=usedIconMouseOver_;
			addChild(currentIcon_);					
		}
		private function onOver(e:MouseEvent):void
		{	
			removeChild(currentIcon_);
			currentIcon_=usedIconMouseOver_;
			addChild(currentIcon_);		
		}
		private function onOut(e:MouseEvent):void
		{
			removeChild(currentIcon_);
			currentIcon_=usedIcon_;
			addChild(currentIcon_);				
		}
		private function onClick(e:MouseEvent):void
		{
			switchStyle();
		}
		// 3 style modifiers
		//setStyle : is made to choose a state
		//switch : is made to switch the current one
		//change : is called by previous functions and save the modifications
		private function setStyle(isOn:Boolean):void
		{			
			isOn_=isOn;
			removeChild(currentIcon_);		
			changeStyle();						
			currentIcon_=usedIcon_;			
			addChild(currentIcon_);
		}
		private function switchStyle():void
		{			
			isOn_=!isOn_;			
			removeChild(currentIcon_);	
			changeStyle();						
			currentIcon_=usedIconMouseOver_;			
			addChild(currentIcon_);
		}
		private function changeStyle():void
		{
			if(isOn_)
			{
				usedIcon_ =  new OptionsMenuButtonOn();
				usedIconMouseOver_ =  new OptionsMenuButtonOnOver();
			}
			else
			{
				usedIcon_ =  new OptionsMenuButtonOff();
				usedIconMouseOver_ =  new OptionsMenuButtonOffOver();
			}
			if(finishedInit)
			{
				//Dispatch event
				var volumeSettings:VolumeEvent;
				if(isMusic)
				{				
					volumeSettings = new VolumeEvent(VolumeEvent.CHANGE_MUSIC);
					volumeSettings.music = isOn_;				
				}
				else
				{				
					volumeSettings = new VolumeEvent(VolumeEvent.CHANGE_SOUND);
					volumeSettings.sound = isOn_;				
				}
				InputEventCannon.mainInstance.dispatchEvent(volumeSettings);
			}
			else
				finishedInit=true;
			
			
		}
	}
	
}
