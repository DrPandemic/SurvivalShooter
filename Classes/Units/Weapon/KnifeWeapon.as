package  {
	
	import flash.display.MovieClip;
	
	
	public class KnifeWeapon extends WorldWeapon {
		public static const KNIFE_DAMAGE:Number = 0.8; // damage per frame on collision
		
		public function KnifeWeapon() {
			super(true, false);
		}
		
		public override function getWeaponDamage():Number
		{
			return KNIFE_DAMAGE;
		}
	}
	
}
