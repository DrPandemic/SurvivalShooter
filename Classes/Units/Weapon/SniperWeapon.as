package  {
	
	import flash.display.MovieClip;
	
	
	public class SniperWeapon extends WorldWeapon {
		
		
		public function SniperWeapon() {
			super(false, false);
		}
		
		public override function getBulletType():Class
		{
			return HighBullet as Class;
		}
	}
	
}
