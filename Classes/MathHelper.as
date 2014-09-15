package  {
	import flash.geom.Point;
	
	public class MathHelper {

		public function MathHelper() {
			// constructor code
		}

		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		// Keeps a value inside the inclusive bounds [min, max].
		// e.g. 
		// clamp(1, -1, 0) == 0, 
		// clamp(-2, 0, 1) == 0, 
		// clamp(2, -100, 100) == 2
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			return Math.max(min, Math.min(max, value));
		}
		
		public static function sign(value:Number):Number
		{
			return value < 0 ? -1 : (value > 0 ? 1 : 0);
		}
		
		public static function asVector(angleDeg:Number, length:Number):Point
		{
			var vec:Point = new Point(
				MathHelper.toDegrees(Math.cos(MathHelper.toRadians(angleDeg))),
				MathHelper.toDegrees(Math.sin(MathHelper.toRadians(angleDeg))));
			vec.normalize(length);
				
			return vec;
		}
		
		public static function randomBinomial():Number
		{
			return Math.random() - Math.random();
		}
		
		// Returns a random ratio based on a passed precision.
		// Example: 90% precision rate of a shooting angle, this will return a number between
		// 0.9 and 1.1 to simply multiply by the perfect shooting angle, effectively altering
		// the precision of the shot.
		public static function getRandomRatioFromPrecision(precision:Number):Number
		{
			var variation:Number = (1.0 - precision);
			var delta:Number = randomBinomial() * variation;
			return 1.0 + delta;
		}
		
		public static function dotProduct(v1:Point, v2:Point):Number
		{
			return (v1.x * v2.x) + (v1.y * v2.y);
		}
		
		public static function angleBetween(v1:Point, v2:Point):Number
		{
			return MathHelper.toDegrees(Math.acos(dotProduct(v1,v2) / (v1.length * v2.length)));
		}
	}
	
}
