package  {
	import flash.events.Event;
	
	public class MapLoadEvent extends Event {
		public static const LOADING_PROGRESS:String = "LoadingProgress";

		public static const LOADING_TILESET:String = "Loading tilesets...";
		public static const LOADING_MAP:String = "Loading map data...";
		public static const RENDERING_MAP:String = "Rendering map...";
		
		public var loadingProgress:String;

		public function MapLoadEvent(type:String, progress:String) {
			super(type);
			
			loadingProgress = progress;
		}

	}
	
}
