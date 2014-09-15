package  {
	import flash.display.MovieClip;
	
	public class PlayerLegsAnimationManager extends AnimationManager {
		public function PlayerLegsAnimationManager(startAnim:String) {
			super();
			addPossibleAnim(IDLE_ANIM, Player_Legs_Idle as Class);
			addPossibleAnim(WALK_ANIM, Player_Legs_Walk as Class);
			
			setAnim(startAnim);
		}

	}
	
}
