package  {
	
	public class MachineGun extends Weapon {

		public function MachineGun() {
			_image = ItemDB.GetItemIngameWorldObject(Inventory.MACHINE_GUN_WEAPON);
			scaleX=0.8;
			scaleY=0.8;
			super(Inventory.MACHINE_GUN_WEAPON);
		}

	}
	
}
