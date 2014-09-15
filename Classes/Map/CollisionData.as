package  {
	import flash.geom.Point;
	
	public class CollisionData {
		public var collision:Boolean;
		public var corner:Boolean;
		public var position:Point;
		public var normal:Point;
		public var depth:Point;
		public var horizontal:Boolean;

		public function CollisionData(hasCollision:Boolean, thePosition:Point, theNormal:Point,
									  theDepth:Point) {
			collision = hasCollision;
			horizontal = false;
			corner = false;
			position = thePosition;
			normal = theNormal;
			depth = theDepth;
		}

	}
	
}
