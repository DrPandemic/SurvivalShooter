package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class FireWaveMapObject extends WorldObject {
		private static const DAMAGE_PER_FRAME:Number = 10;
		
		public function FireWaveMapObject() {
			super(false);
			addEventListener(Event.ENTER_FRAME, onEnterFrame,false,0,true);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				killMe();
			}
		}
		
		public override function update(player:Player, zombies:Array, map:Map):void
		{
			for each (var zombie:Zombie in zombies)
			{
				if (zombie.hitTestObject(this))
				{
					zombie.hurt(DAMAGE_PER_FRAME);
				}
			}
		}
	}
	
}
