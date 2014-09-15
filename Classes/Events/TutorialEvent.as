package  {
	import flash.events.Event;
	
	public class TutorialEvent extends Event {
		public static const COMPLETED_ACTION:String = "Completed tutorial action";
		
		public var actionCompleted:String;
		
		public function TutorialEvent(actionFromTutorialGoals:String) {
			super(COMPLETED_ACTION);
			
			actionCompleted = actionFromTutorialGoals;
		}
	}
	
}
