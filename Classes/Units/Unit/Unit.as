package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Unit extends LivingWorldObject {
		
		private var _bodyWidth:Number;
		protected var _speed:Number;
		private var _direction:Point;
		
		protected var _bodyAnim;
		protected var _legsAnim;
		
		public function Unit(isFriendly:Boolean, speed:Number, bodyWidth:Number, maxHP:Number,
							 bodyAnim:AnimationManager,
							 legsAnim:AnimationManager) {
			super(isFriendly, false, maxHP);
								 
			_bodyWidth = bodyWidth;
			_speed = speed;
			_bodyAnim = bodyAnim;
			_legsAnim = legsAnim;
			_direction = new Point();
			
			addChild(_legsAnim);
			addChild(_bodyAnim);
			
			_bodyAnim.rotationZ = Math.random() * 360; // random start angle
		}
		
		protected function canMove():Boolean
		{
			return true;
		}
		
		// Call this on every tick
		public function applyMove():void
		{
			if (isDead() || !canMove()) 
				dontMove(); // stop moving if we're dead
		
			if (isMoving()) // adjust our speed and animation if we want to move
			{
				if (_direction.length > _speed)
					_direction.normalize(_speed);
				
				// No more legs. Uncomment to see them
				/*const MAX_ANGLE_DIRECTION_LOOKAT_TO_SHOW_LEGS:Number = 90;
				if (Math.abs(MathHelper.angleBetween(_direction, new Point(Math.cos(MathHelper.toRadians(getLookAtAngleDegrees())),
																		   Math.sin(MathHelper.toRadians(getLookAtAngleDegrees())))))
					<= MAX_ANGLE_DIRECTION_LOOKAT_TO_SHOW_LEGS)
				{
					_legsAnim.setAnim(AnimationManager.WALK_ANIM);
					_legsAnim.rotationZ = MathHelper.toDegrees(Math.atan2(_direction.y, _direction.x));
				}
				else
					_legsAnim.setAnim(AnimationManager.IDLE_ANIM);*/
			}
			else // immobile
			{
				_legsAnim.setAnim(AnimationManager.IDLE_ANIM);
			}
			
			// move in the desired direction
			x += _direction.x;
			y += _direction.y;
			
			if (isMoving())
				onMoved();
			
			// reset direction
			_direction.x = _direction.y = 0;
		}
		
		public function collidesWith(object:WorldObject):Boolean
		{
			return _bodyAnim.hitTestObject(object);
		}
		
		public function move(deltaX:Number, deltaY:Number):void
		{
			_direction.x += deltaX;
			_direction.y += deltaY;
		}
		
		public function isMoving():Boolean
		{
			return _direction.x != 0 || _direction.y != 0;
		}
		
		public function dontMove():void
		{
			_direction.x = _direction.y = 0;
		}
		
		public function getBodyWidth():Number
		{
			return _bodyWidth;
		}
		
		public override function getHitDistance():Number
		{
			return getBodyWidth();
		}
		
		public function lookAt(position:Point):void
		{
			if (isDead()) return;
			var dX:Number = position.x - x;
			var dY:Number = position.y - y;
			_bodyAnim.rotationZ = MathHelper.toDegrees(Math.atan2(dY, dX));
		}
		
		public function lookAhead():void
		{
			_bodyAnim.rotationZ = MathHelper.toDegrees(Math.atan2(_direction.y, _direction.x));
		}
		
		public function getLookAtAngleDegrees():Number
		{
			return _bodyAnim.rotationZ;
		}
		
		public function setLookAtAngleDegrees(angle:Number):void
		{
			_bodyAnim.rotationZ = angle;
		}
	}
	
}
