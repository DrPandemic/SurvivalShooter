package  {
	import flash.events.Event;
	
	public class WeaponEvent extends Event {
		public static const BULLET_SHOT:String = "BulletShot";
		
		public var bulletStartX:Number;
		public var bulletStartY:Number;
		
		public var parentStartX:Number;
		public var parentStartY:Number;
		
		public var bulletType:Class;
		public var orientationDegrees:Number;
		public var bulletSource:WorldObject;

		public function WeaponEvent(type:String) {
			super(type);
			bulletStartX = 0;
			bulletStartY = 0;
			
			parentStartX = 0;
			parentStartY = 0;
			
			orientationDegrees = 0;
			bulletSource = null;
		}

	}
	
}
