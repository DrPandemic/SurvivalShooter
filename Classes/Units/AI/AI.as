package  {
	import flash.geom.Point;
	
	public class AI {
		private static const WANDER_STATE:String = "Wander";
		private static const CHASE_STATE:String = "Chase";
		
		private static const DEFAULT_NORMAL_SPEED:Number = Zombie.SPEED;
		private static const DEFAULT_WANDER_SPEED:Number = 0.4 * DEFAULT_NORMAL_SPEED;
		
		private static const DEFAULT_CHASE_ROTATION_SPEED:Number = 10;
		
		private static const DEFAULT_SIGHT_DISTANCE:Number = Map.TILE_H * 4;
		private static const DEFAULT_SIGHT_VISION_ANGLE:Number = 120;
		
		private static const SIGHT_PARAMETERS_PRECISION:Number = 0.9;
		
		private static const FRAMES_FOR_PATH_UPDATE:Number = 600/GameScreen.MILLISECS_PER_FRAME;
		private static const FRAMES_FOR_STATE_CHANGE_CHECK:Number = 200/GameScreen.MILLISECS_PER_FRAME;
		
		private const PATH_LENGTH_TO_GIVEUP_ON_PLAYER:Number = 4;
		
		private var _zombie:Zombie;
		
		private var _path:Path;
		private var _pathfinder:PathFinder;
		private var _map:Map;
		
		private var _currentState:String;
		
		private var _wanderSpeed:Number;
		private var _chaseSpeed:Number;
		private var _rotationSpeed:Number;
		
		private var _sightDistance:Number;
		private var _sightVisionAngle:Number;
		
		private var _target:WorldObject;
		private var untargetPlayer:Boolean;
		private var oldPathLength:Number;
		
		private var _framesSinceLastPathUpdate:Number;
		private var _framesSinceLastStateChangeCheck:Number;

		public function AI(zombie:Zombie, map:Map) {
			
			oldPathLength = 0;
			untargetPlayer = false;
			
			_zombie = zombie;
			
			_currentState = WANDER_STATE;
			
			_map = map;
			_pathfinder = new PathFinder(map);
			
			_framesSinceLastPathUpdate = 0;
			_framesSinceLastStateChangeCheck = 0;
			
			_wanderSpeed = _zombie.speedRatio * DEFAULT_WANDER_SPEED;
			_chaseSpeed = _zombie.speedRatio * DEFAULT_NORMAL_SPEED;
			_rotationSpeed = _zombie.rotationSpeedRatio * DEFAULT_CHASE_ROTATION_SPEED;
				
			_sightDistance = MathHelper.getRandomRatioFromPrecision(SIGHT_PARAMETERS_PRECISION) * DEFAULT_SIGHT_DISTANCE;
			_sightVisionAngle = MathHelper.getRandomRatioFromPrecision(SIGHT_PARAMETERS_PRECISION) * DEFAULT_SIGHT_VISION_ANGLE;
			
			tryTarget(getRandomTile());
		}

		public function getMove(map:Map, player:Player):Point
		{
			var _force:Point = getDesiredForce(map, player);
			
			restrictToMaxSpeed(_force);
			return _force;
		}
		
		private function restrictToMaxSpeed(vector:Point):void
		{
			if (vector.length > getMaxSpeed()) // don't bust maximal possible speed
				vector.normalize(getMaxSpeed()); // bring it back to maximal
		}
		
		private function getMaxSpeed():Number
		{
			var speed:Number;
			switch (_currentState)
			{
				case WANDER_STATE: 
					speed = _wanderSpeed; 
					break;
					
				default: 
					speed = _chaseSpeed; 
					break;
			}
			return speed;
		}
		
		private function getDesiredForce(map:Map, player:Player):Point
		{
			_currentState = getCurrentState(map, player);
			
			var force:Point;
			switch (_currentState)
			{
				case WANDER_STATE: 
					force = wander(); 
					break;
					
				case CHASE_STATE: 
					force = chase(); 
					break;
				
				default: throw new Error("AI state not supported.");
			}
			return force;
		}
		
		private function getCurrentState(map:Map, player:Player):String
		{
			if (_target != null && !_target.isTargetable()) // our target can't be targeted anymore: reset it
			{
				resetTarget();
			}
			
			if (_target == null || _currentState == WANDER_STATE) // no target or wandering: find a target
			{
				++_framesSinceLastStateChangeCheck; // we passed one more frame waiting to check for a new state
				
				if (_framesSinceLastStateChangeCheck >= FRAMES_FOR_STATE_CHANGE_CHECK) // we've waited long enough to check to change state
				{
					_framesSinceLastStateChangeCheck = 0; // reset our counter since we checked for a target
					
					if (isOnSightAndTargetIfItIs(player)) // try to target a player
					{
						if (!untargetPlayer) // If we're supposed to avoid targetting the player, don't exit yet, try to target something else before
							return CHASE_STATE;
					}
						
					if (isAnyOnSightAndTargetIfOneIs(_map.getObjectsOfClass(AutoTurretMapObject as Class)) ||  // try to target turrets
						isAnyOnSightAndTargetIfOneIs(_map.getObjectsOfClass(ProductivityBoosterMapObject as Class)) ||  // try to target productivity boosters
						isAnyOnSightAndTargetIfOneIs(_map.getResourceObjects()) || // try to target resources
						isAnyOnSightAndTargetIfOneIs(_map.getObjectsOfClass(BrickWallMapObject as Class)) ||  // try to target barriers
						isAnyOnSightAndTargetIfOneIs(_map.getObjectsOfClass(RockWallMapObject as Class)))  // try to target rock walls
					{
						untargetPlayer = false; // we've targetted something else than the player: we can stop avoiding it
						return CHASE_STATE;
					}
				}
					
				// couldn't target any : wander around
				return WANDER_STATE;
			}
			else // we already have a target: chase it
			{
				return CHASE_STATE;
			}
		}
		
		public function tryTarget(target:WorldObject):Boolean
		{
			if (target == null) return false; // no target
			if (!target.isTargetable()) return false; // not targetable
			
			_target = target;
			findPathToTarget(); // try to find a path
			
			if (_path == null) // no path to it
			{
				resetTarget();
				return false;
			}
			
			return true; // valid target!
		}
		
		private function isAnyOnSightAndTargetIfOneIs(arr:Array):Boolean
		{
			var lastTargetedDistance:Number = Number.MAX_VALUE;
			var targetedOne:Boolean = false;
			
			for each (var obj:WorldObject in arr)
			{
				// only check to target the closest
				var distance:Number = new Point(obj.x - _zombie.x, obj.y - _zombie.y).length;
				if (distance < lastTargetedDistance && // closer one: check to target it
					isOnSightAndTargetIfItIs(obj))
				{
					targetedOne = true;
					lastTargetedDistance = distance;
				}
			}
			
			return targetedOne;
		}
		
		private function isOnSightAndTargetIfItIs(target:WorldObject):Boolean
		{
			if (target == null) return false; // no target passed
			if (!target.isTargetable()) return false; // target can't be targeted
			
			// Code highly inspired by http://blog.wolfire.com/2009/07/linear-algebra-for-game-developers-part-2/
			var zombPos:Point = new Point(_zombie.x, _zombie.y);
			var zombFacing:Point = MathHelper.asVector(_zombie.getLookAtAngleDegrees(), 1);
			var targetPos:Point = new Point(target.x, target.y);
			
			var zombToTarget:Point = targetPos.subtract(zombPos);
			
			var inSight:Boolean = false;
			if (zombToTarget.length <= _sightDistance) // if the target is close enough
			{
				// Check if it's within our vision range
				inSight = MathHelper.angleBetween(zombFacing, zombToTarget) <= _sightVisionAngle / 2;
			}
			if (!inSight) return false; // not in our vision cone
			
			return tryTarget(target); // try to target it if we see it
		}
		
		private function findPathToTarget():void
		{
			var zombTile:Tile = _map.getTileUnder(_zombie.x, _zombie.y);
			var targetTile:Tile = _map.getTileUnder(_target.x, _target.y);
			
			var oldPath:Path = _path;
			
			_path = _pathfinder.GetPath(zombTile, targetTile);
			
			if (_target is Unit && // we're aiming at a moving target
				oldPath != null && // we had an old path
				_path != null && // and we have a new one
				_path.length() - oldPathLength >= PATH_LENGTH_TO_GIVEUP_ON_PLAYER) // and the change of path is too long (added a wall or something)
			{
				resetTarget();
				untargetPlayer = true; // avoid targetting the player then
			}
			
			oldPathLength = _path != null ? _path.length() : 0;
			
			if (_path == null) 
				resetTarget();
			else
				_path.smooth_path(new Point(_zombie.x, _zombie.y), _target, _map);
			_framesSinceLastPathUpdate = 0;
		}
		
		public function resetTarget():void
		{
			_target = null;
			_path = null;
			oldPathLength = 0;
		}
		
		public function onAttacked(source:WorldObject):void
		{
			var oldTarget:WorldObject = _target;
			
			resetTarget();
			if (!tryTarget(source)) // try to target the hurting source
			{
				// If we couldn't we roll back to our old target
				tryTarget(oldTarget);
			}
		}
		
		private function wander():Point
		{
			return wanderRandomTile();
		}
		
		private function getRandomTile():Tile
		{
			return _map.getRandomWalkableTile();
		}
		
		private function wanderRandomTile():Point
		{
			if (closeEnoughForNextWanderTile()) {
				tryTarget(getRandomTile());
			}
				
			return chase();
		}
		
		private function closeEnoughForNextWanderTile():Boolean
		{
			const CLOSE_ENOUGH_DISTANCE:Number = Map.TILE_W / 2;
			const CLOSE_ENOUGH_DISTANCE_SQ:Number = CLOSE_ENOUGH_DISTANCE * CLOSE_ENOUGH_DISTANCE;
			if (_target == null) return true; // no target: choose next
			
			var dx:Number = _target.x - _zombie.x;
			var dy:Number = _target.y - _zombie.y;
			
			return dx * dx + dy * dy <= CLOSE_ENOUGH_DISTANCE_SQ;
		}
		
		// Do not use this function yet, it does not work properly.
		private function wall_avoidance():Point
		{
			throw new Error("Do not use the function \"wall_avoidance\", it does not work properly.");
			const LOOK_AHEAD:Number = 0.5 * Zombie.BODY_WIDTH;
			const AVOID_DISTANCE:Number = 0.5 * Zombie.BODY_WIDTH;
			
			// Find the ray in front of us
			var velocity:Point = MathHelper.asVector(_zombie.getLookAtAngleDegrees(), _wanderSpeed);
			var rayVector:Point = velocity;
			rayVector.normalize(LOOK_AHEAD);
			
			// Get the collision data of that
			var collisionData:CollisionData = _map.getCollisionData(_zombie, rayVector);
			
			// No collision on our next frame? No need to modify our vector!
			if (!collisionData.collision)
				return velocity;
				
			// Against a corner? try to aim away from it
			if (collisionData.corner)
				return seek(new Point(_zombie.x, _zombie.y).subtract(velocity), _wanderSpeed);
				
			// Create a target to avoid the collision
			collisionData.normal.normalize(AVOID_DISTANCE);
			var target:Point = collisionData.position.add(collisionData.normal);
			
			// Seek the target
			return seek(target, _wanderSpeed);
		}
		
		private function chase():Point
		{
			++_framesSinceLastPathUpdate;
			
			if (_framesSinceLastPathUpdate >= FRAMES_FOR_PATH_UPDATE)
			{
				_framesSinceLastPathUpdate -= FRAMES_FOR_PATH_UPDATE;
				findPathToTarget(); 
			}
			if (_target == null) return new Point(_zombie.x, _zombie.y);
			
			var targetPos:Point = new Point(_target.x, _target.y); // assume we'll just chase our target
			if (_path != null && // if we're following a path
				_path.pathIsNeeded()) // and we actually NEED it (we can't just walk in a straight line to our target)
			{
				var targetTile:Tile = _path.getTargetNode(new Point(_zombie.x, _zombie.y));
				if (targetTile != null) // if we still have a path to follow
				{
					targetPos = new Point(targetTile.x+Map.TILE_W/2, targetTile.y+Map.TILE_H/2);
				}
			}
			
			return seek(targetPos, _chaseSpeed);
		}
		
		private function seek(target:Point, speed:Number):Point
		{
			var desired:Point = new Point(target.x - _zombie.x, target.y - _zombie.y);
			var desiredAngle:Number = MathHelper.toDegrees(Math.atan2(desired.y, desired.x));
			
			var currentAngle:Number = _zombie.getLookAtAngleDegrees();
			
			var desiredRotation:Number = desiredAngle - currentAngle;
			desiredRotation = mapAngleToRange(desiredRotation);
			if (Math.abs(desiredRotation) > _rotationSpeed)
			{
				desiredRotation = MathHelper.sign(desiredRotation) * _rotationSpeed;
			}
			
			_zombie.setLookAtAngleDegrees(currentAngle + desiredRotation);
			return desired;
		}
		
		// Keeps angle between -180 and 180
		private function mapAngleToRange(angleDegrees:Number):Number
		{
			const DEGREES_PER_CIRCLE:Number = 360;
			const DEGREES_PER_HALF_CIRCLE:Number = 180;
			while (angleDegrees <= -DEGREES_PER_HALF_CIRCLE)
				angleDegrees += DEGREES_PER_CIRCLE;
			while (angleDegrees > DEGREES_PER_HALF_CIRCLE)
				angleDegrees -= DEGREES_PER_CIRCLE;
			return angleDegrees;
		}
		
		public function get target():WorldObject
		{
			return _target;
		}
	}
	
}
