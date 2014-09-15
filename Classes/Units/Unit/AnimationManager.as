package  {
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	public class AnimationManager extends MovieClip {
		public static const IDLE_ANIM:String = "Idle";
		public static const WALK_ANIM:String = "Walk";
		public static const DIE_ANIM:String = "Die";
		public static const SPAWN_ANIM:String = "Spawn";
		public static const TAKE_OUT_WEAPON_ANIM:String = "TakeOutWeapon";
		public static const MELEE_ATTACK_ANIM:String = "MeleeAttack";
		public static const SHOOT_ANIM:String = "Shoot";
		

		private var _currentAnim:String;
		private var _currentAnimClip:MovieClip;
		
		private var _possibleAnims:Dictionary;
		private var _animEndCallbacks:Dictionary;

		public function AnimationManager() {
			_currentAnimClip = null;
			_possibleAnims = new Dictionary();
			_animEndCallbacks = new Dictionary();
		}
		
		protected function addPossibleAnim(animStr:String, animClass:Class):void
		{
			_possibleAnims[animStr] = animClass;
		}
		
		public function addAnimationEndCallback(animStr:String, func:Function):void
		{
			_animEndCallbacks[animStr] = func;
		}
		
		public function getCurrentAnimClip():MovieClip
		{
			return _currentAnimClip;
		}

		public function setAnim(newAnim:String):void
		{
			if (newAnim != _currentAnim) // we're changing anim
			{
				// Remove the old animation
				if (_currentAnimClip != null)
				{
					if (_animEndCallbacks[_currentAnim]) // if we had a callback
						_currentAnimClip.removeEventListener(Event.COMPLETE, onCallback); // remove it
					removeChild(_currentAnimClip);
					_currentAnimClip = null;
				}
				
				_currentAnim = newAnim;
				
				if (_possibleAnims[_currentAnim] == undefined) throw new Error("Animation not supported for entity.");
				
				_currentAnimClip = new (_possibleAnims[_currentAnim])();
				
				// if we have a callback for this animation, call it on end of animation
				if (_animEndCallbacks[_currentAnim] != undefined) 
					_currentAnimClip.addEventListener(Event.COMPLETE, onCallback,false,0,true);
				
				// Add the new
				addChild(_currentAnimClip);
			}
		}
		
		public function getCurrentAnim():String
		{
			return _currentAnim;
		}
		
		private function onCallback(e:Event):void
		{
			_currentAnimClip.removeEventListener(Event.COMPLETE, onCallback);
			_animEndCallbacks[_currentAnim](e); // actually call the callback
		}
	}
	
}
