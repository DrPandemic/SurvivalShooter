package  {
	
	public class AutoTurret extends Tech {

		public function AutoTurret() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.AUTO_TURRET);
			scaleX=0.8;
			scaleY=0.8;
			
			super(Inventory.AUTO_TURRET);
			
		}

	}
	
}
