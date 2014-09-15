package  {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class PerformanceProfiler {
		private static var data:Dictionary = new Dictionary();
		private static var lastStartedObjects:Array = new Array();
		
		public function PerformanceProfiler() {
		}
		
		// The name of the object we're profiling
		public static function start(obj:Object):void
		{
			if (data[obj] == undefined) 
				data[obj] = new Object();
			data[obj].start = getTimer();
			lastStartedObjects.push(obj);
		}
		
		// The name of the object we're stopping the timer for
		// Passing null will stop the last started object -> CAREFUL WITH TESTS IN TESTS!
		public static function stop(obj:Object = null):void
		{
			if (lastStartedObjects.length == 0)
			{
				warning("You are trying to call stop on \"" + obj.toString() + "\" when it has
					  never started profiling.");
				return;
			}
			
			if (obj == null) // we want to use the last started one
			{
				obj = lastStartedObjects[lastStartedObjects.length - 1]; 
			}
			
			if (data[obj] == undefined) 
			{
				warning("You are trying to call stop on \"" + obj.toString() + "\" when it has
					  never started profiling.");
				return;
			}
			
			lastStartedObjects.pop(); // use that object here
			
			if (data[obj].total == undefined) data[obj].total = 0.0;
			data[obj].total += getTimer() - data[obj].start;
		}
		
		private static function warning(error:String):void
		{
			trace("*WARNING!* " + error);
		}
		
		// Avoids the start/stop combo by just passing an anonymous function to execute and profile
		// Example: profile("createZombie", { createZombie(); } );
		public static function profile(name:String, func:Function):void
		{
			start(name);
			func.call();
			stop(name);
		}
		
		// Starts a new test, ending the previous one if there was one.
		// CAREFUL WITH TESTS INSIDE OTHER TESTS, DON'T USE!
		public static function startNew(obj:Object):void
		{
			if (lastStartedObjects.length != 0) stop();
			start(obj);
		}

		// Shows the data to the traced output
		public static function show():void
		{
			if (lastStartedObjects.length != 0)
				warning("You have some profiled items(" + lastStartedObjects.length.toString() +
					  "\") that didn't call \"stop\"!");
			for (var obj:Object in data)
			{
				trace("[" + obj.toString() + "] - " + data[obj].total);
			}
			
		}
	}
	
}
