package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Zombie extends Unit {
		public static const SPEED:Number = 3.55;
		private static const SLOW_SPEED:Number = 1;
		public static const BODY_WIDTH:Number = 37.5;
		private static const HEALTH:Number = 50;
		public static const ATTACK_RANGE:Number = 0.75 * BODY_WIDTH;
		public static const DAMAGE_PER_HIT:Number = 5;
		
		private static const MOVE_SPEED_PRECISION:Number = 0.85;
		private static const ROTATION_SPEED_PRECISION:Number = 0.96;
		
		private static const SLOW_DOWN_PER_FRAME:Number = 0.1;
		
		public var ai:AI;
		public var maxSpeed:Number;
		public var speedRatio:Number;
		public var rotationSpeedRatio:Number;
		
		private var slowdown:Number;
		private var slowed:Boolean;
		
		public function Zombie(map:Map) {
			super(false, SPEED, BODY_WIDTH, HEALTH,
				  new ZombieBodyAnimationManager(), 
				  new PlayerLegsAnimationManager(AnimationManager.IDLE_ANIM));
				  
			_bodyAnim.addAnimationEndCallback(AnimationManager.DIE_ANIM, onDieAnimEnd);
			_bodyAnim.addAnimationEndCallback(AnimationManager.SPAWN_ANIM, onSpawnAnimEnd);
			_bodyAnim.addAnimationEndCallback(AnimationManager.MELEE_ATTACK_ANIM, onMeleeAttackEnd);
				  
			_bodyAnim.setAnim(AnimationManager.SPAWN_ANIM);
			invincible = true; // can't be hit while spawning
			
			speedRatio = MathHelper.getRandomRatioFromPrecision(MOVE_SPEED_PRECISION);
			rotationSpeedRatio = MathHelper.getRandomRatioFromPrecision(ROTATION_SPEED_PRECISION);
			_speed *= speedRatio;
			maxSpeed = _speed;
			
			slowdown = 0;
			slowed = false;
			
			ai = new AI(this, map);
		}
		
		protected override function canMove():Boolean
		{
			return _bodyAnim.getCurrentAnim() == AnimationManager.IDLE_ANIM;
		}
		
		public function onMeleeAttackEnd(e:Event):void
		{
			_bodyAnim.setAnim(AnimationManager.IDLE_ANIM);
		}
		
		private function onSpawnAnimEnd(e:Event):void
		{
			_bodyAnim.setAnim(AnimationManager.IDLE_ANIM);
			invincible = false;
		}
		
		public function isAttacking():Boolean
		{
			return _bodyAnim.getCurrentAnim() == AnimationManager.MELEE_ATTACK_ANIM;
		}
		
		public function attack(obj:LivingWorldObject):void
		{
			if (_bodyAnim.getCurrentAnim() == AnimationManager.IDLE_ANIM)
			{
				obj.hurt(Zombie.DAMAGE_PER_HIT);
				_bodyAnim.setAnim(AnimationManager.MELEE_ATTACK_ANIM);
			}
		}
		
		private function onDieAnimEnd(e:Event):void
		{
			cleanMe();
		}
		
		protected override function died():void
		{
			_bodyAnim.setAnim(AnimationManager.DIE_ANIM);
			applyMove(); // make sure we stop moving
		}
		
		public function updateSlowdown():void
		{
			if (slowdown != 0)
			{
				// We find the ratio of slowdown that we must apply
				var slowdownRatio:Number = slowdown;
				// And reduce the speed according to the ratio of slowdown
				_speed = SLOW_SPEED + (maxSpeed - SLOW_SPEED) * (1 - slowdownRatio);
			}
			
			// If we didn't get slowed last frame
			if (!slowed)
			{
				slowdown -= SLOW_DOWN_PER_FRAME; // we undo the slow effect
				slowdown = MathHelper.clamp(slowdown, 0, 1); // keep a ratio value
			}
			slowed = false; // undo the slowed tag
				
		}
		
		public function slowDown():void
		{
			slowed = true;
			slowdown += SLOW_DOWN_PER_FRAME;
			slowdown = MathHelper.clamp(slowdown, 0, 1); // keep a ratio value
		}
	}
	
}
