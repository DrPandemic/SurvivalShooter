package  {
	
	public class Ammo extends Item {

		public function Ammo(type:String=Inventory.AMMO2) {
			_image = new AmmoDisplay();
			scaleX=0.8;
			scaleY=0.8;
			super(type);
		}

	}
	
}
