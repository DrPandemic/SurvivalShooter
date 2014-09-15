package  {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.events.ProgressEvent;
	
	public class MapLoader extends JSONParser {

		private var map_url:String;
		
		private static const MAP_TILES_LAYER:Number = 0;
		private static const MAP_SPAWNS_LAYER:Number = 1;
		
		private static const PLAYER_SPAWN:String = "player";
		private static const RESOURCE_BASE_SPAWN:String = "base resource spawn";
		private static const RESOURCE_TECH_SPAWN:String = "tech resource spawn";
		private static const RESOURCE_PROGRESS_SPAWN:String = "progress resource spawn";
		
		private var _map:Map;
		private var _tilesetLoader:TilesetLoader;
		
		private var _playerSpawnIndices:Point;
		private var _resourceSpawnIndices:Dictionary;
		

		public function MapLoader() {
			
			_tilesetLoader = new TilesetLoader();
			map_url=new String();
		}
		
		// Fires the "Event.COMPLETE" event when the map is fully loaded.
		public function loadMap(level:Number):void
		{
			map_url=Map.getMapUrl(level);
			dispatchEvent(new MapLoadEvent(MapLoadEvent.LOADING_PROGRESS,
										   MapLoadEvent.LOADING_TILESET));
			_tilesetLoader.loadTileset(Map.getTilesetUrl(level));
			_tilesetLoader.addEventListener(Event.COMPLETE, onTilesetLoaded,false,0,true);
		}
		
		override protected function handleLoadedObject(data:Object):void
		{
			var indices:Array = data["layers"][MAP_TILES_LAYER]["data"];
			
			var width:Number = data["width"];
			var height:Number = data["height"];
			
			var mapIndices:Array = new Array();
			
			for (var y:Number = 0; y < height; ++y)
			{
				mapIndices.push(new Array());
				for (var x:Number = 0; x < width; ++x)
				{
					mapIndices[y].push(indices[y*width + x]);
				}
			}
			
			extractSpawnIndices(width, height,
								data["layers"][MAP_SPAWNS_LAYER]["data"]);
			
			_map = new Map(mapIndices, 
						   _tilesetLoader.getTileset(),
						   _playerSpawnIndices,
						   _resourceSpawnIndices);
			
			dispatchEvent(new Event(Event.COMPLETE)); // we are completly done (map and tileset loaded)
			
			dispatchEvent(new MapLoadEvent(MapLoadEvent.LOADING_PROGRESS,
										   MapLoadEvent.RENDERING_MAP));
		}
		
		private function extractSpawnIndices(mapWidth:Number, mapHeight:Number,
											 spawnIndices:Array):void
		{
			_resourceSpawnIndices = new Dictionary();
			_resourceSpawnIndices[Inventory.BASE_RESOURCE] = new Array();
			_resourceSpawnIndices[Inventory.TECH_RESOURCE] = new Array();
			_resourceSpawnIndices[Inventory.PROGRESS_RESOURCE] = new Array();
			
			for (var y:Number = 0; y < mapHeight; ++y)
			{
				for (var x:Number = 0; x < mapWidth; ++x)
				{
					var obj:String = _tilesetLoader.getObjectForSpawnId(spawnIndices[y*mapWidth + x]);
					
					if (obj == PLAYER_SPAWN)
					{
						_playerSpawnIndices = new Point(x, y);
					}
					else if (obj == RESOURCE_BASE_SPAWN)
					{
						_resourceSpawnIndices[Inventory.BASE_RESOURCE].push(new Point(x, y));
					}
					else if (obj == RESOURCE_TECH_SPAWN)
					{
						_resourceSpawnIndices[Inventory.TECH_RESOURCE].push(new Point(x, y));
					}
					else if (obj == RESOURCE_PROGRESS_SPAWN)
					{
						_resourceSpawnIndices[Inventory.PROGRESS_RESOURCE].push(new Point(x, y));
					}
				}
			}
		}
		
		private function onTilesetLoaded(e:Event):void
		{
			_tilesetLoader.removeEventListener(Event.COMPLETE, onTilesetLoaded);
			
			dispatchEvent(new MapLoadEvent(MapLoadEvent.LOADING_PROGRESS,
										   MapLoadEvent.LOADING_MAP));
			load(map_url);
		}
		
		public function getMap():Map
		{
			return _map;
		}
	}
	
}
