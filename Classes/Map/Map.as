package  {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class Map extends MovieClip {
		public static const TILE_W:Number = 48;
		public static const TILE_H:Number = 48;
		
		// The indices of every tiles stored this way: indices[y][x]
		private var _mapTileIndices:Array;
		private var _mapTiles:Array;
		private var _walkableTiles:Vector.<Tile>;
		
		// Indices of spawn points
		private var _playerSpawnIndices:Point;
		private var _resourceSpawnPoints:Dictionary;
		
		// An array of every tile class for every tile index (e.g. tileset[0] == "GrassTile")
		private var _tileset:Array;
		
		// A list of the map objects associated to the tile they are on.
		private var _mapObjects:Dictionary;
		
		// A list of each element associated by their classes.
		// For example, a key could be "AutoTurret" and the value the list of all the AutoTurrets placed.
		private var _mapObjectsByClasses:Dictionary;
		private var _resources:Array;
		private var _destroyable:Array;
		private var _unbuildableTiles:Array;
		
		// Layers/containers
		private var _effectObjects:Array;
		private var _objetsContainer:MovieClip;
		public static var effectsContainer:MovieClip;
		public static var entitiesContainer:MovieClip;
		public static var _hpBarContainer:MovieClip;
		public static var resourceControlContainer:MovieClip;
		private var _tilesContainer:Sprite;
		
		public var camera:Camera;

		public function Map(mapTileIndices:Array, tileset:Array, playerSpawnIndices:Point,
							resourceSpawnPoints:Dictionary) {
			_mapTileIndices = mapTileIndices;
			_playerSpawnIndices = playerSpawnIndices;
			_resourceSpawnPoints = resourceSpawnPoints;
			_tileset = tileset;
			camera = new Camera();
			_mapObjects = new Dictionary(true);
			_mapObjectsByClasses = new Dictionary(true);
			_resources = new Array();
			_destroyable = new Array();
			_unbuildableTiles = new Array();
			_effectObjects = new Array();
			_objetsContainer = new MovieClip();
			_hpBarContainer = new MovieClip();
			resourceControlContainer = new MovieClip();
			_tilesContainer = new Sprite();
		}
		
		// Only call this once after the map has been loaded and you want it to be visible.
		public function draw():void
		{
			_mapTiles = new Array();
			_walkableTiles = new Vector.<Tile>();
			for (var tileY:Number = 0; tileY < _mapTileIndices.length; ++tileY)
			{
				_mapTiles.push(new Array());
				for (var tileX:Number = 0; tileX < _mapTileIndices[tileY].length; ++tileX)
				{
					var tileClass:Class = _tileset[_mapTileIndices[tileY][tileX]] as Class;
					var tile:Tile = new tileClass();
					tile.x = (int)(tileX * TILE_W);
					tile.y = (int)(tileY * TILE_H);
					tile.width = TILE_W;
					tile.height = TILE_H;
					_tilesContainer.addChild(tile);
					_mapTiles[tileY].push(tile);
					if (!tile.isBuildable())
						_unbuildableTiles.push(tile);
					if (!tile.isSolid())
						_walkableTiles.push(tile);
				}
			}
			
			// we don't want to redraw the tiles for nothing,
			// so we store them in a container (cached as a bitmap).
			_tilesContainer.cacheAsBitmap = true; 
			addChild(_tilesContainer);
			
			addChild(_objetsContainer);
			addChild(entitiesContainer);
			addChild(resourceControlContainer);
			addChild(effectsContainer);
			addChild(_hpBarContainer);
			
			spawnResources();
		}
		
		// Call this every tick to update the map objects
		public function updateMapObjects(player:Player, zombies:Array):void
		{
			for (var tile:Object in _mapObjects)
			{
				var obj:WorldObject = _mapObjects[tile];
				
				updateWorldObject(obj, _objetsContainer, player, zombies);
				if (obj.shouldBeKilled()) 
				{
					removeMapObject(tile as Tile);
				}
			}
			
			for each(var effect:WorldObject in _effectObjects)
			{
				updateWorldObject(effect, effectsContainer, player, zombies);
				if (effect.shouldBeKilled()) _effectObjects.splice(_effectObjects.indexOf(effect), 1);
			}
		}
		
		private function removeMapObject(tile:Tile):void
		{
			var obj:WorldObject = _mapObjects[tile];
			
			var objectsByClass:Array = _mapObjectsByClasses[GeneralHelper.classOf(obj)];
			objectsByClass.splice(
				objectsByClass.indexOf(obj), 1);
			if (isResource(obj)) _resources.splice(_resources.indexOf(obj), 1);
			if (isDestroyable(obj)) _destroyable.splice(_destroyable.indexOf(obj), 1);
			
			delete _mapObjects[tile];
		}
		
		private function updateWorldObject(obj:WorldObject, container:MovieClip,
										   player:Player, zombies:Array)
		{
			obj.update(player, zombies, this);
			
			if (obj.shouldBeKilled())
			{
				if (obj is LivingWorldObject) (obj as LivingWorldObject).hideHpBar(null);
				container.removeChild(obj);
				return;
			}
			
			if (player.collidesWith(obj))
				obj.onPlayerCollision(player);
		}
		
		private function spawnResources():void
		{
			spawnResourceType(Inventory.BASE_RESOURCE, BaseMapResource as Class);
			spawnResourceType(Inventory.TECH_RESOURCE, TechMapResource as Class);
			spawnResourceType(Inventory.PROGRESS_RESOURCE, ProgressMapResource as Class);
		}
		
		private function spawnResourceType(resourceName:String, resourceType:Class):void
		{
			for each (var point:Point in _resourceSpawnPoints[resourceName])
			{
				var resource = new resourceType();
				addMapObject(resource, getTileAtIndices(point.x, point.y));
				(resource as MapResource).positionCaptureProgress();
			}
		}
		
		// Adds an object to the map that is drawn and updated (e.g. a wall, a resource, etc.)
		public function addMapObject(object:WorldObject, tile:Tile):void
		{
			_mapObjects[tile] = object;
			centerOnTile(object, tile);
			_objetsContainer.addChild(object);
			
			var theClass:Class = GeneralHelper.classOf(object);
			if (_mapObjectsByClasses[theClass] == undefined)
				_mapObjectsByClasses[theClass] = new Array();
			_mapObjectsByClasses[theClass].push(object);
			
			if (isResource(object))
				_resources.push(object);
				
			if (isDestroyable(object))
				_destroyable.push(object);
		}
		
		private function isResource(object:WorldObject):Boolean
		{
			return object is BaseMapResource ||
				object is TechMapResource ||
				object is ProgressMapResource;
		}
		private function isDestroyable(object:WorldObject):Boolean
		{
			return object is LivingWorldObject;
		}
		
		public function getObjectsOfClass(theClass:Class):Array
		{
			if (_mapObjectsByClasses[theClass] == undefined)
				return new Array();
			else
				return _mapObjectsByClasses[theClass];
		}
		
		public function addEffect(effect:WorldObject):void
		{
			_effectObjects.push(effect);
			effectsContainer.addChild(effect);
		}
		
		// Centers the specified object on the tile
		private function centerOnTile(object:WorldObject, tile:Tile)
		{
			object.x = tile.x + TILE_W / 2;
			object.y = tile.y + TILE_H / 2;
		}
		
		public function getTileUnderMouse():Tile
		{
			var indices:Point = getTileIndices(mouseX, mouseY);
			
			return getTileAtIndices(indices.x, indices.y);
		}
		
		private function getTileIndices(worldX:Number, worldY:Number):Point
		{
			return new Point(Math.floor(worldX / TILE_W), Math.floor(worldY / TILE_H));
		}
		
		// Call this every tick
		public function updateCamera(player:Player):void
		{
			camera.followPlayer(player);
			camera.placeMapForCamera(this);
		}
		
		public function getCollisionData(unit:Unit, moveAmount:Point):CollisionData
		{
			var resultCollision:CollisionData = new CollisionData(false,
																  new Point(),
																  new Point(),
																  new Point());
			var collisions:Array = new Array();
			var oldUnitPos:Point = new Point(unit.x, unit.y);
			unit.x += moveAmount.x;
			unit.y += moveAmount.y;
			var tempUnitPos:Point = new Point(unit.x, unit.y);
			
			var touchedTiles:Array = getTilesUnder(unit);
			for each (var tile:Tile in touchedTiles)
			{
				var collision:CollisionData = new CollisionData(false, new Point(), new Point(), new Point());
				if (tile.isSolid())
				{
					collision = getCollisionDataWithObject(unit, tile);
				}
				else if (_mapObjects[tile] != undefined // the tile the unit is on contains an object
					&& _mapObjects[tile].isSolid()) // that object is solid
				{
					collision = getCollisionDataWithObject(unit, _mapObjects[tile]);
				}
				
				// If it's the first collision that we find, mark it as the nearest so far.
				if (!resultCollision.collision && collision.collision)
					resultCollision = collision;
					
				// We select the result collision as the nearest collision on our path.
				if (collision.collision) 
				{
					// The collision is closer to us?
					if (Point.distance(collision.position, tempUnitPos) <
						Point.distance(resultCollision.position, tempUnitPos))
					{
						resultCollision = collision; // select it as the final collision then.
					}
					collisions.push(collision);
				}
			}
			
			var collisionX:Boolean = false;
			var collisionY:Boolean = false;
			
			for each (var theCollision:CollisionData in collisions)
			{
				collisionX = collisionX || theCollision.horizontal;
				collisionY = collisionY || !theCollision.horizontal;
				resultCollision = theCollision;
			}
			// If we have both horizontal and vertical collisions, we're facing a corner.
			var corner:Boolean = collisionX && collisionY;
			resultCollision.corner = corner;
			
			/*if (corner) // We found a corner? Let's go away from the wall in front of us then.
			{
				var goingHorizontal:Boolean = Math.abs(moveAmount.x) > Math.abs(moveAmount.y);
				// Find a collision related to where we're going
				for each (var col:CollisionData in collisions)
				{
					if (goingHorizontal == col.horizontal)
					{
						resultCollision = col;
						break;
					}
				}
				
				resultCollision.corner = corner;
			}*/
			
			// Put back to our current REAL position
			unit.x = oldUnitPos.x;
			unit.y = oldUnitPos.y;
			
			return resultCollision;
		}
		
		private function getCollisionDataWithObject(unit:Unit, object:WorldObject):CollisionData
		{
			var coll:CollisionData = new CollisionData(false, new Point(), new Point(), new Point());
			var depth = getIntersectionDepth(unit, object);
			if (depth.x != 0 && depth.y != 0) // if we are colliding
			{
				coll.collision = true;
				coll.position.x = unit.x;
				coll.position.y = unit.y;
				coll.depth = depth;
				// We find the collision on the less collided side
				if (Math.abs(depth.y) < Math.abs(depth.x))
				{
					coll.position.y += depth.y;
					coll.normal.y = MathHelper.sign(depth.y);
					coll.horizontal = false;
				}
				else
				{
					coll.position.x += depth.x;
					coll.normal.x = MathHelper.sign(depth.x);
					coll.horizontal = true;
				}
			}
			
			return coll;
		}
		
		public function undoCollisions(unit:Unit):void
		{
			var touchedTiles:Array = getTilesUnder(unit);
			for each (var tile:Tile in touchedTiles)
			{
				if (tile.isSolid()) // solid tile: undo collision
				{
					undoSingleCollision(unit, tile);
				}
				
				if (_mapObjects[tile] != undefined // the tile the unit is on contains an object
					&& _mapObjects[tile].isSolid()) // that object is solid
				{
					undoSingleCollision(unit, _mapObjects[tile]); // we undo the collision then
				}
			}
		}
		
		private function undoSingleCollision(unit:Unit, object:WorldObject):void
		{
			// get we are colliding by how much on each axis
			var depth:Point = getIntersectionDepth(unit, object); 
			if (depth.x != 0 && depth.y != 0) // we ARE actually colliding
			{
				// We undo the collision on the less collided side (to hide that we're undoing the collision)
				if (Math.abs(depth.y) < Math.abs(depth.x))
					unit.y += depth.y;
				else
					unit.x += depth.x;
			}
		}
		
		private function getTilesUnder(unit:Unit):Array
		{
			var touchingTiles:Array = new Array();
			
			var halfW:Number = unit.getBodyWidth() / 2;
			var halfH:Number = halfW; // same width and height
			
			var firstX:Number = Math.floor((unit.x - halfW) / TILE_W);
			var lastX:Number = Math.floor((unit.x + halfW) / TILE_W) + 1;
			var firstY:Number = Math.floor((unit.y - halfH) / TILE_H);
			var lastY:Number = Math.floor((unit.y + halfH) / TILE_H) + 1;
			
			for (var yInd:Number = Math.max(firstY, 0); 
				 yInd <= Math.min(lastY, _mapTileIndices.length - 1); ++yInd)
			{
				for (var xInd:Number = Math.max(firstX, 0); 
					 xInd <= Math.min(lastX, _mapTileIndices[yInd].length - 1); ++xInd)
				{
					touchingTiles.push(getTileAtIndices(xInd, yInd));
				}
			}
			
			return touchingTiles;
		}
		
		public function getTileUnder(theX:Number, theY:Number):Tile
		{
			var xInd:Number = Math.floor(theX/ TILE_W);
			var yInd:Number = Math.floor(theY / TILE_H);
			
			return getTileAtIndices(xInd, yInd);
		}
		
		private function getIntersectionDepth(unit:Unit, object:WorldObject):Point
		{
			// Calculate half sizes.
			var bRect:Rectangle = object.getBounds(object.parent);
			
            var halfWidthA:Number = unit.getBodyWidth() / 2.0;
			var halfHeightA:Number = halfWidthA; // same width and height
            var halfWidthB:Number = bRect.width / 2.0;
            var halfHeightB:Number = bRect.height / 2.0;

            // Calculate centers.
            var centerA:Point = new Point(unit.x, unit.y);
            var centerB:Point = new Point(bRect.left + halfWidthB, 
										  bRect.top + halfHeightB);

            // Calculate current and minimum-non-intersecting distances between centers.
            var distanceX:Number = centerA.x - centerB.x;
            var distanceY:Number = centerA.y - centerB.y;
            var minDistanceX:Number = halfWidthA + halfWidthB;
            var minDistanceY:Number = halfHeightA + halfHeightB;

            // If we are not intersecting at all, return (0, 0).
            if (Math.abs(distanceX) >= minDistanceX || Math.abs(distanceY) >= minDistanceY)
                return new Point();

            // Calculate and return intersection depths.
            var depthX:Number = distanceX > 0 ? minDistanceX - distanceX : -minDistanceX - distanceX;
            var depthY:Number = distanceY > 0 ? minDistanceY - distanceY : -minDistanceY - distanceY;
            return new Point(depthX, depthY);
		}
		
		// Returns the tile at the specified tile IDs
		public function getTileAtIndices(theX:Number, theY:Number):Tile
		{
			return areIndicesOnMap(theX, theY) ? // are the indices okay?
				_mapTiles[theY][theX] : // if they are, return the right tile
				null; // otherwise just return null
		}
		
		private function areIndicesOnMap(theX:Number, theY:Number):Boolean
		{
			return theY >= 0 && theY < _mapTileIndices.length &&
				theX >= 0 && theX < _mapTileIndices[0].length;
		}
		
		public function getCenterOfTile(tile:Tile):Point
		{
			return new Point(tile.x + TILE_W / 2, tile.y + TILE_H / 2);
		}
		
		public function getPlayerSpawningTile():Tile
		{
			return getTileAtIndices(_playerSpawnIndices.x, _playerSpawnIndices.y);
		}
		
		public function canBuildOn(tile:Tile, player:Player, zombies:Array):Boolean
		{
			const MIN_BUILD_DIST_SQUARED:Number = Player.MIN_BUILD_DISTANCE * Player.MIN_BUILD_DISTANCE;
			const MAX_BUILD_DIST_SQUARED:Number = Player.MAX_BUILD_DISTANCE * Player.MAX_BUILD_DISTANCE;
			
			var tileCenterX:Number = tile.x + tile.width / 2;
			var tileCenterY:Number = tile.y + tile.height / 2;
			
			var distX:Number = player.x - tileCenterX;
			var distY:Number = player.y - tileCenterY;
			
			// Get the distance from the player to the construction square, to see if it's too far/too close
			var playerTileDistSquared:Number = distX * distX + distY * distY;
			
			// Do the same with the zombies to see if we're trying to build on a zombie
			var closestZombieDistSquared:Number = Number.MAX_VALUE;
			for each (var zombie:Zombie in zombies)
			{
				var zombDistX:Number = zombie.x - tileCenterX;
				var zombDistY:Number = zombie.y - tileCenterY;
				
				var zombieTileDistSquared:Number = zombDistX * zombDistX + zombDistY * zombDistY;
				closestZombieDistSquared = Math.min(closestZombieDistSquared, zombieTileDistSquared);
			}
			
			var nothingIsOnTile:Boolean = tile.canBuildOnIt() && _mapObjects[tile] == undefined;
			var selectedItemIsSolid:Boolean = player.inventory.getSelectedWorldObject().isSolid();
			
			if (selectedItemIsSolid) // we're building something solid
			{
				// MAKE SURE THE DISTANCES ARE SQUARED!!! (optimisation, but must be done by all the distances to work properly)
				return nothingIsOnTile && // tile not occupied by an object/solid tile
					playerTileDistSquared >= MIN_BUILD_DIST_SQUARED && // not too close
					playerTileDistSquared <= MAX_BUILD_DIST_SQUARED && // not too far
					closestZombieDistSquared >= MIN_BUILD_DIST_SQUARED; // not trying to build on a zombie
			}
			else // we're building something not solid
			{
				return nothingIsOnTile && // we can only build on an empty tile.
					playerTileDistSquared <= MAX_BUILD_DIST_SQUARED; // in our build range
			}
		}
		
		public function collidesWithSolidAndNotPenetrable(xPos:Number, yPos:Number):Boolean
		{
			var tileIndices:Point = getTileIndices(xPos, yPos);
			var tile:Tile = getTileAtIndices(tileIndices.x, tileIndices.y);
			
			return tile.isSolid() || // solid tile under
				(_mapObjects[tile] != undefined && _mapObjects[tile].isSolid()
				 && !_mapObjects[tile].bulletsGoThroughIt()); // solid object under
		}
		
		public function getTotalTilesWidth():Number
		{
			return getTilesWidth() * TILE_W;
		}
		public function getTilesWidth():Number
		{
			return _mapTileIndices[0].length;
		}
		public function getTilesHeight():Number
		{
			return _mapTileIndices.length;
		}
		public function getTotalTilesHeight():Number
		{
			return getTilesHeight() * TILE_H;
		}
		
		public function getResourceObjects():Array
		{
			return _resources;
		}
		
		public function getDestroyableObjects():Array
		{
			return _destroyable;
		}
		
		public function getEmptyTiles():Array
		{
			var tiles:Array = new Array();
			
			for (var tileY:Number = 0; tileY < _mapTiles.length; ++tileY)
			{
				for (var tileX:Number = 0; tileX < _mapTiles[tileY].length; ++tileX)
				{
					var tile:Tile = _mapTiles[tileY][tileX];
					if (isEmptyTile(tile)) // no solid object on tile (or no object at all)
					{
						tiles.push(tile);
					}
				}
			}
			
			return tiles;
		}
		
		public function isEmptyTile(tile:Tile):Boolean
		{
			return !tile.isSolid() && // tile is not solid
				(_mapObjects[tile] == undefined || !_mapObjects[tile].isSolid()); // no solid object on tile (or no object at all)
		}
		
         public static function getMapUrl(level:Number):String
		{
			return "maps/map" + level.toString() + "/map.json";
		}
		public static function getTilesetUrl(level:Number):String
		{
			return "maps/map" + level.toString() + "/tileset.json";
		}

                
        public function getNeighbors(tile:Tile):Array		                
		{
			var neighbors:Array = new Array();
			var indX:Number = tile.x / Map.TILE_W;
			var indY:Number = tile.y / Map.TILE_H;
			var n:Tile;
			
			n = getTileAtIndices(indX-1, indY);
			if (n != null) neighbors.push(n);
			n = getTileAtIndices(indX+1, indY);
			if (n != null) neighbors.push(n);
			n = getTileAtIndices(indX, indY-1);
			if (n != null) neighbors.push(n);
			n = getTileAtIndices(indX, indY+1);
			if (n != null) neighbors.push(n);
			return neighbors;
		}
		
		public function walkableToTile(from:Point, to:Tile, entityWidth:Number):Boolean
		{
			return walkableToPos(from, new Point(to.x + Map.TILE_W/2, to.y + Map.TILE_H/2), entityWidth);
		}
		
		public function walkableToPos(from:Point, to:Point, entityWidth:Number,
									  canGoThroughPenetrable:Boolean = false):Boolean
		{
			const STEP:Number = Map.TILE_W/5;
			const EPSILON:Number = STEP;
			const UNIT_HALF_W:Number = entityWidth/2;
			
			var curX:Number = from.x;
			var curY:Number = from.y;
			var goalX:Number = to.x;
			var goalY:Number = to.y;
			
			var step:Point = new Point(goalX-curX, goalY-curY);
			step.normalize(STEP);
			
			while (Math.abs(curX - goalX) + Math.abs(curY - goalY) > EPSILON)
			{
				if (!canGoThrough(getTileUnder(curX, curY), canGoThroughPenetrable) || // center
					!canGoThrough(getTileUnder(curX-UNIT_HALF_W, curY), canGoThroughPenetrable) || // left
					!canGoThrough(getTileUnder(curX+UNIT_HALF_W, curY), canGoThroughPenetrable) || // right
					!canGoThrough(getTileUnder(curX, curY-UNIT_HALF_W), canGoThroughPenetrable) || // top
					!canGoThrough(getTileUnder(curX, curY+UNIT_HALF_W), canGoThroughPenetrable)) // bottom
					return false;
				
				curX += step.x;
				curY += step.y;
			}
			
			return true;
		}
		
		private function canGoThrough(tile:Tile, canGoThroughPenetrable:Boolean):Boolean
		{
			return !tile.isSolid() && // not a solid tile
				(_mapObjects[tile] == undefined || //there's no object there
				 (!_mapObjects[tile].isSolid() || // OR there is no solid object
				  (_mapObjects[tile].bulletsGoThroughIt() && canGoThroughPenetrable))); // OR it is penetrable (and we can go through penetrable tiles)
		}
		
		public function getBuildableTilesAround(player:Player, zombies:Array):Array
		{
			var tiles:Array = new Array();
			
			var firstX:Number = Math.floor((player.x - Player.MAX_BUILD_DISTANCE) / TILE_W);
			var lastX:Number = Math.floor((player.x + Player.MAX_BUILD_DISTANCE) / TILE_W) + 1;
			var firstY:Number = Math.floor((player.y - Player.MAX_BUILD_DISTANCE) / TILE_H);
			var lastY:Number = Math.floor((player.y + Player.MAX_BUILD_DISTANCE) / TILE_H) + 1;
			
			for (var yInd:Number = Math.max(firstY, 0); 
				 yInd <= Math.min(lastY, _mapTileIndices.length - 1); ++yInd)
			{
				for (var xInd:Number = Math.max(firstX, 0); 
					 xInd <= Math.min(lastX, _mapTileIndices[yInd].length - 1); ++xInd)
				{
					var tile:Tile = getTileAtIndices(xInd, yInd); 
					if (canBuildOn(tile, player, zombies))
						tiles.push(tile);
				}
			}
			
			return tiles;
		}
		
		/// Hides the tiles that are not visible right now on the screen
		/// (so that we don't have to draw unecessarily some tiles).
		public function hideTilesNotOnScreen():void
		{
			for (var yInd:int = 0; yInd < _mapTileIndices.length; ++yInd)
			{
				for (var xInd:int = 0; xInd < _mapTileIndices[yInd].length; ++xInd)
				{
					var tile:Tile = getTileAtIndices(xInd, yInd);
					// Only draw it if it is in our screen
					tile.visible = camera.isTileInCameraSight(this, tile.x, tile.y);
				}
			}
		}
		
		/// Returns a random walkable tile from the map.
		public function getRandomWalkableTile():Tile
		{
			return _walkableTiles[(int)(Math.random() * _walkableTiles.length)];
		}
	}
	
}
