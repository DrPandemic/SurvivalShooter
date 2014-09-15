package  {
	
	import flash.display.MovieClip;
	
	
	public class SpikeTrapMapObject extends WorldObject {
		private static const DAMAGE_PER_FRAME:Number = 0.1;
		private static const SET_UP_TIME_MILLISECS:Number = 1000;
		private static const RECHARGE_TIME_MILLISECS:Number = 2000;
		
		private static const UNSET_FRAME:Number = 1;
		private static const SET_UP_FRAME:Number = 2;
		
		private var _isSetUp:Boolean;
		private var _timeSpentSetUp:Number;
		
		private var _isRecharged:Boolean;
		private var _timeSpentRecharing:Number;
		
		public function SpikeTrapMapObject() {
			super(false);
			unset();
			_isRecharged = false;
		}
		
		public override function update(player:Player, zombies:Array, map:Map):void
		{
			if (_isSetUp) // only stay set up for a certain amount of times, then unload
			{
				_timeSpentSetUp += GameScreen.MILLISECS_PER_FRAME;
				
				if (_timeSpentSetUp >= SET_UP_TIME_MILLISECS)
					unset();
			}
			else if (!_isRecharged) // we are recharging after the trap has been set up completely
			{
				_timeSpentRecharing += GameScreen.MILLISECS_PER_FRAME;
				
				if (_timeSpentRecharing >= RECHARGE_TIME_MILLISECS)
					recharge();
			}
			if (_isSetUp || _isRecharged) // if interaction with zombies change anything
			{
				for each (var zombie:Zombie in zombies)
				{
					if (zombie.hitTestObject(this))
					{
						if (_isSetUp)
						{
							zombie.hurt(DAMAGE_PER_FRAME);
							zombie.slowDown();
						}
						else if (_isRecharged)
						{
							setUp();
						}
					}
				}
			}
		}
		
		private function setUp():void
		{
			_timeSpentSetUp = 0;
			_isSetUp = true;
			_isRecharged = false;
			gotoAndStop(SET_UP_FRAME);
		}
		
		private function unset():void
		{
			_isSetUp = false;
			_timeSpentRecharing = 0;
			gotoAndStop(UNSET_FRAME);
		}
		
		private function recharge():void
		{
			_isRecharged = true;
		}
	}
	
}
