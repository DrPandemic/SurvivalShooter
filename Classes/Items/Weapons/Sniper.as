package  {
	
	public class Sniper extends Weapon {

		public function Sniper() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.SNIPER_WEAPON);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.SNIPER_WEAPON);
		}

	}
	
}
