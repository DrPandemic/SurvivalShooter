package  {
	
	public class Tile extends WorldObject {
		public function Tile(isSolid:Boolean, isBuildable:Boolean = true) {
			super(isSolid, isBuildable);
			cacheAsBitmap = true;
		}
		
		public override function isTargetable():Boolean
		{
			return !isSolid(); // we can target it if it is not solid (used for pathfinding, if we can walk through it)
		}
	}
	
}
