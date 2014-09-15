package  {
	
	// Helper class to register tutorial events easily
	public class Tutorial {

		public static function onDone(action:String):void
		{
			InputEventCannon.mainInstance.dispatchEvent(new TutorialEvent(action));
		}

	}
	
}
