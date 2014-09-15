package  {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class OptionsMenuScrollBar extends MovieClip {
		
		private var RectangleBar_:MovieClip;
		private var Line_:MovieClip;
		private var isOverRectangle:Boolean;
		private var isRectanglePress:Boolean;
		
		public function OptionsMenuScrollBar() {
			isOverRectangle=false;
			isRectanglePress=false;
			
			RectangleBar_= new OptionsMenuScrollBarRectangle();
			Line_= new OptionsMenuScrollBarLine();
					
			addChild(Line_);
			addChild(RectangleBar_);
			
			Line_.buttonMode = true;
			Line_.mouseChildren = false;
			Line_.doubleClickEnabled = false;
			RectangleBar_.buttonMode = true;
			RectangleBar_.mouseChildren = false;
			RectangleBar_.doubleClickEnabled = false;		
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,false,0,true);
			
		}
		private function onAddedToStage(e:Event):void
		{
				
			Line_.addEventListener(MouseEvent.MOUSE_DOWN, lineDown ,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN, rectangleDown ,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP, rectangleUp,false,0,true);
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMoved,false,0,true);
			
			//To receive the saved settings
			InputEventCannon.mainInstance.addEventListener(VolumeEvent.RESOND,onRespondVolumeSettings,false,0,true);
			InputEventCannon.mainInstance.dispatchEvent(new VolumeEvent(VolumeEvent.ASK));		
		}
		private function onRespondVolumeSettings(e:VolumeEvent):void
		{
			InputEventCannon.mainInstance.removeEventListener(VolumeEvent.RESOND,onRespondVolumeSettings);
			setPosition(e.soundLevel);
		}
		private function lineDown(e:MouseEvent):void
		{				
			changePosition(mouseX);
		}
		private function rectangleDown(e:MouseEvent):void
		{	
			isRectanglePress=true;
		}
		private function rectangleUp(e:MouseEvent):void
		{	
			isRectanglePress=false;
		}
		private function onMouseMoved(e:MouseEvent):void
		{
			if ((mouseX>=-width/2 && mouseX<=width/2) && isRectanglePress)
			{
				changePosition(mouseX);
			}
		}
		//Is call to transforme pixel into ratio and call the setPosition
		private function changePosition(pos:Number)
		{
			pos+=width/2;
			pos=10*pos/width;
			
			setPosition(pos);
		}
		public function setPosition(pos:Number):void
		{
			if(pos >= 0 && pos <=10)
			{
				RectangleBar_.x = width*((pos-5)/10);
				var volumeSettings:VolumeEvent = new VolumeEvent(VolumeEvent.CHANGE_SOUND_LEVEL);
				volumeSettings.soundLevel =  pos;
				InputEventCannon.mainInstance.dispatchEvent(volumeSettings);
			}
			
		}
				
	}
	
}
