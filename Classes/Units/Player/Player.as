package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	
	
	public class Player extends Unit {
		private static const KNIFE_SPEED_BOOST:Number = 0.3;
		
		private static const MIN_SPEED:Number = 3;
		private static const SPRINT_SPEED:Number = 4.5;
		private static const MAX_SPEED:Number = SPRINT_SPEED;
		public static const MOVE_AS_FAST_AS_POSSIBLE:Number = 99999;
		private static const BODY_WIDTH:Number = 37.5;
		
		public static const MAX_LIFE:Number = 100;
		
		private static const STAMINA_REDUCTION_PER_FRAME:Number = 0.01;
		private static const STAMINA_REBOOST_PER_FRAME:Number = 0.015;
		
		public static const MIN_BUILD_DISTANCE:Number = BODY_WIDTH;
		public static const MAX_BUILD_DISTANCE:Number = Map.TILE_W + Map.TILE_H;
		
		public var inventory:Inventory;
		public var sprinting:Boolean;
		private var stamina:Number;
		
		private var _weapon:WorldWeapon;
		
		public function Player() {
			super(true, MIN_SPEED, BODY_WIDTH, MAX_LIFE,
				  new PlayerBodyAnimationManager(),
				  new PlayerLegsAnimationManager(AnimationManager.IDLE_ANIM));
			
			inventory = new Inventory();
			
			_bodyAnim.addAnimationEndCallback(AnimationManager.TAKE_OUT_WEAPON_ANIM, onTakeOutWeaponAnimEnd);
			_bodyAnim.addAnimationEndCallback(AnimationManager.MELEE_ATTACK_ANIM, onMeleeAttackAnimEnd);
			_bodyAnim.addAnimationEndCallback(AnimationManager.SHOOT_ANIM, onShootAnimEnd);
			_bodyAnim.addAnimationEndCallback(AnimationManager.DIE_ANIM, onDieAnimEnd);
			
			// start by picking up our first weapon.
			changeCurrentWeapon(new KnifeWeapon());
			
			stamina = 1;
		}
		
		private function getSpeedBoost():Number
		{
			return _weapon is KnifeWeapon ? KNIFE_SPEED_BOOST : 0.0;
		}
		
		protected override function canMove():Boolean
		{
			return _bodyAnim.getCurrentAnim() == AnimationManager.TAKE_OUT_WEAPON_ANIM ||
				_bodyAnim.getCurrentAnim() == AnimationManager.MELEE_ATTACK_ANIM ||
				_bodyAnim.getCurrentAnim() == AnimationManager.SHOOT_ANIM ||
				_bodyAnim.getCurrentAnim() == AnimationManager.IDLE_ANIM;
		}
		
		public function updateSprint():void
		{
			// We update the stamina
			if (sprinting)
				stamina -= STAMINA_REDUCTION_PER_FRAME;
			else
				stamina += STAMINA_REBOOST_PER_FRAME;
				
			// We keep a valid stamina
			stamina = MathHelper.clamp(stamina, 0, 1);
				
			// We update the speed according to the current stamina(which is a percentage)
			// if we're sprinting
			if (sprinting)
			{
				var speedModificator:Number = Math.pow(stamina, 1/4);
				_speed = MIN_SPEED + (SPRINT_SPEED - MIN_SPEED) * speedModificator;
			}
			else
				_speed = MIN_SPEED;
			
			// We keep a valid speed
			_speed = MathHelper.clamp(_speed, MIN_SPEED, SPRINT_SPEED);
			
			// We reached the minimum speed? not sprinting anymore.
			// We are not moving anymore? not sprinting anymore.
			if (sprinting &&
				(_speed == MIN_SPEED ||
				!isMoving()))
			{
				sprinting = false;
			}
			
			_speed += getSpeedBoost();
			
			// Check for tutorial events
			if (isMoving())
			{
				// running
				if (sprinting) Tutorial.onDone(TutorialGoals.MOVE_RUN);
				
				// walking
				else Tutorial.onDone(TutorialGoals.MOVE_WALK);
			}
		}
		
		public function changeCurrentWeapon(weapon:WorldWeapon):void
		{
			if (_weapon != null) _weapon.onAnimEnd();
			_weapon = weapon;
			_weapon.owner = this;
			_bodyAnim.setBodyAnim(AnimationManager.TAKE_OUT_WEAPON_ANIM, _weapon);
		}
		
		public function retakeCurrentWeapon():void
		{
			changeCurrentWeapon(_weapon);
		}
		
		public function attack():void
		{
			if (_bodyAnim.getCurrentAnim() == AnimationManager.IDLE_ANIM &&
				_weapon.canShoot())
			{
				_weapon.onShoot();
				
				if (_weapon.isMelee) // melee attack
				{
					_bodyAnim.setBodyAnim(AnimationManager.MELEE_ATTACK_ANIM, _weapon);
					Tutorial.onDone(TutorialGoals.ATTACK_KNIFE);
				}
					
				else // gun attack
				{
					gunAttack();
				}
			}
		}
		
		public function updateWeapon():void
		{
			_weapon.updateVisibility();
		}
		
		private function gunAttack():void
		{
			// Do we have enough ammo to shoot with our gun type?
			if (inventory.hasEnoughAmmo(_weapon.getBulletTypeString(),
										1))
			{
				_bodyAnim.setBodyAnim(AnimationManager.SHOOT_ANIM, _weapon);
				
				// spawn a bullet
				var bulletsShot:Number = spawnBullets();
				
				// remove the fired bullets from the inventory
				inventory.removeAmmo(_weapon.getBulletTypeString(),
									 bulletsShot);
			}
			else
			{
				//TODO: gun empty sound?
				inventory.pickMeleeWeapon();
			}
		}
		
		// Returns the amount of bullets shot
		private function spawnBullets():Number
		{
			// Don't shoot more bullets than what we have
			var count:Number = Math.min(inventory.getAmmoQuantity(_weapon.getBulletTypeString()),
										_weapon.getBulletsAngleDifferences().length);
										
			for (var i:Number = 0; i < count; ++i)
			{
				var weaponClip = _weapon;
				var event:WeaponEvent = new WeaponEvent(WeaponEvent.BULLET_SHOT);
				
				var notRotatedX:Number = _bodyAnim.getCurrentAnimClip().weaponAssetHolder.x + weaponClip.ammoSpawn.x; 
				var notRotatedY:Number = _bodyAnim.getCurrentAnimClip().weaponAssetHolder.y + weaponClip.ammoSpawn.y;
				
				event.bulletStartX = 
					notRotatedX * Math.cos(MathHelper.toRadians(getLookAtAngleDegrees())) -
					notRotatedY * Math.sin(MathHelper.toRadians(getLookAtAngleDegrees()));
				event.bulletStartY = 
					notRotatedX * Math.sin(MathHelper.toRadians(getLookAtAngleDegrees())) +
					notRotatedY * Math.cos(MathHelper.toRadians(getLookAtAngleDegrees()));
					
				event.parentStartX = x;
				event.parentStartY = y;
				
				event.bulletType = _weapon.getBulletType();
				
				event.orientationDegrees = getLookAtAngleDegrees() + _weapon.getBulletsAngleDifferences()[i];
				
				event.bulletSource = this;
				
				dispatchEvent(event);
			}
			
			return count;
		}
		
		public function automaticAttack():void
		{
			if (_weapon.isAutomatic)
				attack();
		}
		
		private function onTakeOutWeaponAnimEnd(e:Event):void
		{
			_bodyAnim.setBodyAnim(AnimationManager.IDLE_ANIM, _weapon);
		}
		
		private function onMeleeAttackAnimEnd(e:Event):void
		{
			_bodyAnim.setBodyAnim(AnimationManager.IDLE_ANIM, _weapon);
			_weapon.onAnimEnd();
		}
		
		private function onShootAnimEnd(e:Event):void
		{
			_bodyAnim.setBodyAnim(AnimationManager.IDLE_ANIM, _weapon);
			_weapon.onAnimEnd();
		}
		
		public function getWeapon():WorldWeapon
		{
			return _weapon;
		}
		
		public function isMeleeHurtingEntity(entity:WorldObject):Boolean
		{
			return _weapon.isMelee &&
				_bodyAnim.getCurrentAnim() == AnimationManager.MELEE_ATTACK_ANIM &&
				_weapon.hitTestObject(entity);
		}
		
		private function onDieAnimEnd(e:Event):void
		{
			cleanMe();
		}
		
		protected override function died():void
		{
			_bodyAnim.setBodyAnim(AnimationManager.DIE_ANIM, _weapon);
		}
		
		public function getWeaponDamage():Number
		{
			return _weapon.getWeaponDamage();
		}
		
		protected override function onHpChanged():void 
		{ 
			InputEventCannon.mainInstance.dispatchEvent( new CharacterEvent(CharacterEvent.LIFE,getHp()));
		}
	}
	
}
