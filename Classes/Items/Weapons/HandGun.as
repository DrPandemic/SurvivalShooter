package  {
	
	public class HandGun extends Weapon {

		public function HandGun() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.HANDGUN_WEAPON);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.HANDGUN_WEAPON);
		}

	}
	
}
