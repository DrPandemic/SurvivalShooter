package  {
	
	public class ProdBooster extends Tech {

		public function ProdBooster() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.PROD_BOOSTER);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.PROD_BOOSTER);
		}

	}
	
}
