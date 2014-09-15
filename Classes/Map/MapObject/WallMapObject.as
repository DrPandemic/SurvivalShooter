package  {
	
	public class WallMapObject extends LivingWorldObject {

		public function WallMapObject(hp:Number) {
			super(true, true, hp);
			cacheAsBitmap = true;
		}
		
		override public function update(player:Player, zombies:Array, map:Map):void
		{
			super.update(player, zombies, map);
			if (player.getWeapon() is KnifeWeapon &&
				player.isMeleeHurtingEntity(this))
			{
				hurt(player.getWeaponDamage());
				
				// Update the tutorial about destroying our own walls
				Tutorial.onDone(TutorialGoals.HURT_WALL_HIT_WALL);
			}
		}

	}
	
}
