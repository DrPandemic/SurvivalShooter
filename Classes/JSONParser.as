package  {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class JSONParser extends EventDispatcher {

		protected var _urlLoader:URLLoader = new URLLoader();
		protected var _data:Object;

		public function JSONParser() {
		}
		
		// Calls "handleLoadedObject" when the download is over
		protected function load(fileName:String):void
		{
			var request:URLRequest = new URLRequest(fileName);
			_urlLoader.addEventListener(Event.COMPLETE, handleDownload,false,0,true);
			_urlLoader.load(request);
		}

		private function handleDownload(e:Event):void
		{
			_data = JSON.parse(_urlLoader.data);

			handleLoadedObject(_data);
		}
		
		// Overload this if you want to load the desired object.
		// Use the data["key-name"] to access what you want.
		protected function handleLoadedObject(data:Object):void
		{
		}
	}
	
}
