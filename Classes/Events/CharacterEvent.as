package  {
	import flash.events.Event;
	
	public class CharacterEvent extends Event {
		
		public static const AMMO:String="Ammo";
		public static const AMMO2:String="Ammo2";
		
		public static const LIFE:String="Life";

		
		public var quantity:Number;

		public function CharacterEvent(type:String,_quantity:Number) {
			super(type);
			quantity=_quantity;
		}

	}
	
	
}
