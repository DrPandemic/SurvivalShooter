package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class AutoTurretMapObject extends LivingWorldObject {
		private static const SECONDS_FOR_ONE_TURN:Number = 3;
		private static const MILISECS_BETWEEN_SHOTS:Number = 100;
		public static const RANGE:Number = Map.TILE_H * 5;
		
		private const MAX_ROTATE_PER_FRAME:Number = 
			360 / (SECONDS_FOR_ONE_TURN * 1000 / GameScreen.MILLISECS_PER_FRAME);
		private var _timeSinceLastShot:Number;
		
		private var _target:Zombie;
		
		public function AutoTurretMapObject() {
			super(true, false, 25);
			_timeSinceLastShot = 0;
			_target = null;
		}
		
		public override function update(player:Player, zombies:Array, map:Map):void
		{
			if (_target != null && _target.isDead()) _target = null;
			if (canShoot() && 
				((_target != null && zombieInRange(_target, map))
				|| anyZombieInRange(zombies, map)))
			{
				shoot(player);
			}
			else
			{
				_timeSinceLastShot += GameScreen.MILLISECS_PER_FRAME;
				
				if (_target == null)
					top.rotationZ += MAX_ROTATE_PER_FRAME;
			}
		}
		
		private function zombieInRange(zombie:Zombie, map:Map):Boolean
		{
			const BULLET_PASSAGE_WIDTH:Number = 2;
			var angleRad:Number = MathHelper.toRadians(top.rotationZ);
			
			var visionX:Number = Math.cos(angleRad);
			var visionY:Number = Math.sin(angleRad);
			var visionLineSlope:Number = visionY / visionX;
			
			/*
			ax+b=y

			slope(x)+b=y
			b = y-slope(x)
			*/
			var visionLineB:Number = y - visionLineSlope * x;
			
			var perpenticularLineSlope:Number = -1 / visionLineSlope;
			
			var deltaX:Number = zombie.x - x;
			var deltaY:Number = zombie.y - y;
			
			var perpenticularLineB:Number = zombie.y - perpenticularLineSlope * zombie.x;
			
			/*
			tur.y = visSlope(tur.x) + visB
			z.y = perSlope(z.x) + perB

			visSlope(x) + visB = perSlope(x)+perB
			visSlope(x) = perSlope(x) + perB - visB
			visSlope(x) - perSlope(x) = perB - visB
			(visSlope-perSlope)(x) = perB - visB
			x = (perB - visB)/(visSlope-perSlope)
			*/
			var meetX:Number = (perpenticularLineB - visionLineB)/(visionLineSlope-perpenticularLineSlope);
			var meetY:Number = visionLineSlope * meetX + visionLineB;
			var meetPoint:Point = new Point(meetX, meetY);
			
			
			// If we're aiming at a zombie
			if (MathHelper.sign(deltaX) == MathHelper.sign(visionX) && MathHelper.sign(deltaY) == MathHelper.sign(visionY) && // zombie is on the same side as the vision (not behind)
				Point.distance(meetPoint, new Point(zombie.x, zombie.y)) <= zombie.getBodyWidth() / 2 && // If our ray cast touches the zombie (its closest point on our vision ray is smaller than its width)
				Point.distance(meetPoint, new Point(x, y)) - zombie.getBodyWidth() / 2 <= RANGE) // and the zombie is close enough
			{
				// And the path between both is clear
				if (map.walkableToPos(new Point(x, y), 
									new Point(zombie.x, zombie.y), 
									BULLET_PASSAGE_WIDTH, true))
				{
					_target = zombie;
					return true; // shoot!
				}
			}
			
			if (zombie == _target) _target = null; // can't aim at our target anymore? reset target
			return false;
		}
		
		private function canShoot():Boolean
		{
			return _timeSinceLastShot >= MILISECS_BETWEEN_SHOTS;
		}
		
		private function shoot(player:Player):void
		{
			if (player.inventory.hasEnoughAmmo(Inventory.AMMO, 1))
			{
				_timeSinceLastShot = 0;
				
				var event:WeaponEvent = new WeaponEvent(WeaponEvent.BULLET_SHOT);
				
				var notRotatedX:Number = top.x + top.ammoSpawn.x; 
				var notRotatedY:Number = top.y + top.ammoSpawn.y;
				
				event.bulletStartX = 
					notRotatedX * Math.cos(MathHelper.toRadians(top.rotationZ)) -
					notRotatedY * Math.sin(MathHelper.toRadians(top.rotationZ));
				event.bulletStartY = 
					notRotatedX * Math.sin(MathHelper.toRadians(top.rotationZ)) +
					notRotatedY * Math.cos(MathHelper.toRadians(top.rotationZ));
					
				event.parentStartX = x;
				event.parentStartY = y;
					
				event.bulletType = NormalBullet as Class;
					
				event.orientationDegrees = top.rotationZ;
				
				event.bulletSource = this;
				
				player.dispatchEvent(event);
				
				player.inventory.removeAmmo(Inventory.AMMO, 1);
			}
		}
		
		private function anyZombieInRange(zombies:Array, map:Map):Boolean
		{
			for each (var zombie:Zombie in zombies)
			{
				if (zombieInRange(zombie, map))
					return true;
			}
			return false;
		}
	}
	
}
