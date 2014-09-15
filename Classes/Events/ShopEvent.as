package  {
	import flash.events.Event;
	
	public class ShopEvent extends Event {
		
		public var theItem:Item;
		public static const BUY:String = "buy";
		public static const SELECT:String = "select";

		public function ShopEvent(e:Item,type:String=SELECT) {
			super(type);
			theItem=e;
		}

	}
	
}
