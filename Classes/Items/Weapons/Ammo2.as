package  {
	
	public class Ammo2 extends Item {

		public function Ammo2(type:String=Inventory.AMMO2) {
			_image = new Ammo2Display();
			scaleX=0.8;
			scaleY=0.8;
			super(type);
		}

	}
	
}
