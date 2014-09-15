package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class FiniteAnimationClip extends MovieClip {

		// Animation that stops after it reaches its last frame, instead of rolling infinitely.
		public function FiniteAnimationClip() {
			addEventListener(Event.ENTER_FRAME, onEnterFrame,false,0,true); 
		}

		private function onEnterFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
	
}
