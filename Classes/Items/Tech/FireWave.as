package  {
	
	public class FireWave extends Weapon {

		public function FireWave() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.FIRE_WAVE);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.FIRE_WAVE);
		}

	}
	
}
