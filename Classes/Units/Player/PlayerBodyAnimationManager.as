package  {
	import flash.display.MovieClip;
	
	public class PlayerBodyAnimationManager extends AnimationManager {
		public function PlayerBodyAnimationManager() {
			super();
			addPossibleAnim(IDLE_ANIM, Player_Body_Idle as Class);
			addPossibleAnim(TAKE_OUT_WEAPON_ANIM, Player_Body_TakeOutWeapon as Class);
			addPossibleAnim(MELEE_ATTACK_ANIM, Player_Body_MeleeAttack as Class);
			addPossibleAnim(SHOOT_ANIM, Player_Body_Shoot as Class);
			addPossibleAnim(DIE_ANIM, Player_Body_Die as Class);
		}
		
		public function setBodyAnim(anim:String, weapon:WorldWeapon):void
		{
			setAnim(anim);
			setHeldWeapon(weapon);
		}
		
		public function setHeldWeapon(weapon:WorldWeapon):void
		{
			getCurrentAnimClip().weaponAssetHolder.changeWeaponAsset(weapon);
		}
	}
	
}
