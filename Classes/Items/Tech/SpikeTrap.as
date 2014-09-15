package  {
	
	public class SpikeTrap extends Tech {

		public function SpikeTrap() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.SPIKE_TRAP);
			super(Inventory.SPIKE_TRAP);
			scaleX=0.8;
			scaleY=0.8;
		}

	}
	
}
