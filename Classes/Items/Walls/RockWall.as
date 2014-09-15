package  {
	
	public class RockWall extends Wall {

		public function RockWall() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.ROCK_WALL);
			super(Inventory.ROCK_WALL);
			scaleX=0.8;
			scaleY=0.8;
		}

	}
	
}
