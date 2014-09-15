package  {
	import flash.events.Event;
	
	public class ConfirmEvent extends Event {
		public static const YES:String = "Yes";
		public static const NO:String = "No";

		public function ConfirmEvent(type:String) {
			super(type);
		}

	}
	
}
