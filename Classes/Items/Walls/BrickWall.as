package  {
	
	public class BrickWall extends Wall {

		public function BrickWall() {
			
			_image = ItemDB.GetItemIngameWorldObject(Inventory.BRICK_WALL);
			super(Inventory.BRICK_WALL);
			scaleX=0.8;
			scaleY=0.8;
		}

	}
	
}
