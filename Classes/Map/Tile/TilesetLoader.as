package  {
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	
	public class TilesetLoader extends JSONParser {
		
		private var tileset:Array;
		private var spawnObjectsForIds:Dictionary;

		public function TilesetLoader() {
			tileset = null;
			spawnObjectsForIds = null;
		}
		
		// Fires the "Event.COMPLETE" event when the tileset is fully loaded.
		public function loadTileset(tileset:String):void
		{
			load(tileset);
		}
		
		override protected function handleLoadedObject(data:Object):void
		{
			tileset = new Array();
			var tilesArray:Array = data["tiles"];
			
			for each(var tileObj:Object in tilesArray)
			{
				tileset[tileObj["id"]] = getDefinitionByName(tileObj["flashClass"]);
			}
			
			spawnObjectsForIds = new Dictionary();
			var spawnsArray:Array = data["spawns"];
			
			for each (var spawnObj:Object in spawnsArray)
			{
				spawnObjectsForIds[spawnObj["id"]] = spawnObj["object"];
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		public function getTileset():Array
		{
			return tileset;
		}

		public function getObjectForSpawnId(id:Number):String
		{
			return spawnObjectsForIds[id];
		}
	}
	
}
