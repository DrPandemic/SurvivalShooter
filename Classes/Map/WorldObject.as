package  {
	import flash.display.MovieClip;
	
	public class WorldObject extends MovieClip {
		private var _isSolid:Boolean;
		protected var penetrable:Boolean;
		private var _isBuildable:Boolean;
		private var _removeMe:Boolean; // Should we remove that object from the map?

		public function WorldObject(isSolid:Boolean, isBuildable:Boolean = true) {
			_isSolid = isSolid;
			_isBuildable = isBuildable;
			_removeMe = false;
			penetrable = false;
		}
		
		public function isSolid():Boolean
		{
			return _isSolid;
		}
		
		// If bullets can go through it
		public function bulletsGoThroughIt():Boolean
		{
			return penetrable;
		}
		
		public function canBuildOnIt():Boolean
		{
			return !isSolid() && _isBuildable;
		}
		
		public function isBuildable():Boolean
		{
			return _isBuildable;
		}
		
		public function onPlayerCollision(player:Player):void
		{
		}
		
		public function update(player:Player, zombies:Array, map:Map):void
		{
		}
		
		// Remove the object from the map
		public function killMe():void
		{
			_removeMe = true;
		}
		
		// If we should remove that object from the map
		public function shouldBeKilled():Boolean
		{
			return _removeMe;
		}
		
		public function isTargetable():Boolean
		{
			return false;
		}
		
		public function getHitDistance():Number
		{
			return (width + height) / 2;
		}
	}
	
}
