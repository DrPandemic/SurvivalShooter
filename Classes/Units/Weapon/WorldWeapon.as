package  {
	import flash.display.MovieClip;
	
	public class WorldWeapon extends WorldObject {

		public var isMelee:Boolean;
		public var isAutomatic:Boolean;
		public var owner:Player;
		
		public function WorldWeapon(melee:Boolean, automatic:Boolean) {
			super(false);
			isMelee = melee;
			isAutomatic = automatic;
			cacheAsBitmap = true;
			owner = null;
		}
		
		public function getBulletType():Class
		{
			return NormalBullet as Class;
		}
		
		public function getBulletsAngleDifferences():Array
		{
			var angles:Array = new Array();
			angles.push(0);
			return angles;
		}
		
		public function getBulletTypeString():String
		{
			if (getBulletType() == NormalBullet) return Inventory.AMMO;
			else if (getBulletType() == HighBullet) return Inventory.AMMO2;
			else if (getBulletType() == GrenadeBullet) return Inventory.FIRE_WAVE;
			else throw new Error("Inexistent bullet type.");
		}
		
		public function updateVisibility():void
		{
		}
		
		public function onShoot():void
		{
		}
		
		public function canShoot():Boolean
		{
			return true;
		}
		
		public function onAnimEnd():void
		{
		}
		
		public function getWeaponDamage():Number
		{
			return 0;
		}
	}
	
}
