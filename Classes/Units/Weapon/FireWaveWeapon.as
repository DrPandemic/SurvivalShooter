package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	public class FireWaveWeapon extends WorldWeapon {
		
		static const RECHARGE_TIME_MILLISECONDS:Number = 1500;
		
		static var frameOfLastShot:Number = 
			-RECHARGE_TIME_MILLISECONDS / GameScreen.MILLISECS_PER_FRAME;// start charged
		
		public function FireWaveWeapon() {
			super(false, false);
		}
		
		public override function canShoot():Boolean
		{
			var rechargedTime:Number = GameScreen.MILLISECS_PER_FRAME * 
					(GameScreen.FrameCount - frameOfLastShot);
			if (rechargedTime >= RECHARGE_TIME_MILLISECONDS)
			{
				frameOfLastShot = GameScreen.FrameCount;
				
				// Check to update the tutorial
				Tutorial.onDone(TutorialGoals.GRENADE_SHOOT);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public override function updateVisibility():void
		{
			var previousVisible:Boolean = visible;
			visible = GameScreen.MILLISECS_PER_FRAME * 
					(GameScreen.FrameCount - frameOfLastShot) >= RECHARGE_TIME_MILLISECONDS;
					
			if (!previousVisible && visible) // it just recharged
				owner.retakeCurrentWeapon();
		}
		
		public override function getBulletType():Class
		{
			return GrenadeBullet as Class;
		}
	}
	
}
