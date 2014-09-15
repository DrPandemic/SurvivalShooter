package  {
	
	public class Bullet extends WorldObject {
		
		private var _speed:Number;
		private var _damage:Number;
		private var _penetrable:Boolean;
		public var source:WorldObject;

		public function Bullet(speed:Number, damage:Number, penetrable:Boolean, theSource:WorldObject) {
			super(false);
			_speed = speed;
			_damage = damage;
			_penetrable = penetrable;
			source = theSource;
			cacheAsBitmap = true;
		}
		
		public function move():void
		{
			x += Math.cos(MathHelper.toRadians(rotationZ)) * _speed;
			y += Math.sin(MathHelper.toRadians(rotationZ)) * _speed;
		}
		
		public function getDamage():Number
		{
			return _damage;
		}
		
		public function isPenetrable():Boolean
		{
			return _penetrable;
		}
		
		public function onDestroy():void
		{
		}
	}
	
}
