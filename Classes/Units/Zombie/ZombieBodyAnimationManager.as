package  {
	
	public class ZombieBodyAnimationManager extends AnimationManager {

		public function ZombieBodyAnimationManager() {
			super();
			addPossibleAnim(IDLE_ANIM, Zombie_Body_Idle as Class);
			addPossibleAnim(MELEE_ATTACK_ANIM, Zombie_Body_Attack as Class);
			addPossibleAnim(DIE_ANIM, Zombie_Body_Die as Class);
			addPossibleAnim(SPAWN_ANIM, Zombie_Body_Spawn as Class);
		}

	}
	
}
