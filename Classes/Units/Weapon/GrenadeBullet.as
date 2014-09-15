package  {
	
	import flash.display.MovieClip;
	
	
	public class GrenadeBullet extends Bullet {
		
		public function GrenadeBullet(source:WorldObject) {
			super(12, 15, false, source);
			
			cacheAsBitmap = false;
		}
		
		public override function onDestroy():void
		{
			var e:WeaponEvent = new WeaponEvent(WeaponEvent.BULLET_SHOT);
			
			e.bulletStartX = x;
			e.bulletStartY = y;
			
			dispatchEvent(e);
		}
	}
	
}
