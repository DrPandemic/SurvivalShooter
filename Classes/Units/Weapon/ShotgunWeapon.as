package  {
	
	import flash.display.MovieClip;
	
	
	public class ShotgunWeapon extends WorldWeapon {
		private static const BULLET_SPREAD_ANGLE:Number = 10;
		
		public function ShotgunWeapon() {
			super(false, false);
		}
		
		public override function getBulletsAngleDifferences():Array
		{
			var angles:Array = new Array();
			angles.push(-BULLET_SPREAD_ANGLE, 0, BULLET_SPREAD_ANGLE);
			return angles;
		}
	}
	
}
