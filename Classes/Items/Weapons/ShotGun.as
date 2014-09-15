package  {
	
	public class ShotGun extends Weapon {

		public function ShotGun() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.SHOTGUN_WEAPON);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.SHOTGUN_WEAPON);
		}

	}
	
}
