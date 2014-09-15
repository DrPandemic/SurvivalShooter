package  {
	
	import flash.display.MovieClip;
	
	
	public class HighBullet extends Bullet {
		
		
		public function HighBullet(source:WorldObject) {
			super(15,
				  5, // damage per frame on collision
				  true,
				  source);
		}
	}
	
}
