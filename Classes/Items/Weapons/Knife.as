package  {
	
	public class Knife extends Weapon {

		public function Knife() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.KNIFE_WEAPON);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.KNIFE_WEAPON);
		}

	}
	
}
