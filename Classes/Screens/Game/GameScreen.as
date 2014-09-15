package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	
	public class GameScreen extends Screen {
		public const MAX_ZOMBIES:Number = 50;
		public static const MILLISECS_PER_FRAME:Number = 33.3333;
		public static var FrameCount:Number = 0;
		public const START_AMMO_AMOUNT:Number = 25;
		private const TUTORIAL_LEVEL:Number = 1;
		private const MILLISECONDS_FOR_LIFE_REGEN:Number = 10000;
		private const LIFE_REGEN_AMOUNT:Number = 5;
		private const TIME_FOR_KEY_DOUBLETAP_MILLISECS:Number = 300;
		
		private const CURRENTLY_BUILDING_ITEM_ALPHA:Number = 0.2;
		
		// Used for debugging purposes.
		static var ActiveGameScreenInstances:Number = 0; 
				
		// General game objects
		private var gameTimer:Timer;
		private var _isPaused:Boolean;
		private var _isMouseUp:Boolean;
		
		// Loading
		private var _level:Number;
		private var _mapLoader:MapLoader;
		
		// Environment
		private var _map:Map;
		
		// Layers
		public static var effectsLayer:MovieClip;
		private var _entitiesLayer:MovieClip;
		private var _buildModeLayer:MovieClip;
		private var _underUI:MovieClip;
		
		// Player
		private var _player:Player;
		private var _buildMode:Boolean;
		private var _playerWantsAutomaticShoot:Boolean;
		private var _bullets:Array;
		private var _levelResourceGoals:LevelResourceGoals;
		private var _levelStartInventory:LevelStartingInventory;
		private var _timeSinceLastLifeRegen:Number = 0;
		private var _moveInputLastUp:Dictionary;
		private var lastMoveKeyReleased:uint;

		// Enemies
		private var _enemies:Array;
		private var _spawner:ZombieSpawner;

		// Options Menu
		private var optionsMenuScreen:OptionsMenuScreen;
		
		// Shop
		public var shopScreen:ShopMenuScreen;
		
		// Lose/Win
		private var deathScreen:DeathScreen;
		private var winScreen:LevelWinScreen;
		private var levelEndAnim:LevelEndAnimation;
		
		//UI
		private var UI:GameUI;
		private var _selectedTile:BuildModeTileSelectionOverlay;
		private var _buildableTiles:Array;
		private var _buildableTilesContainer:MovieClip;
		private var _currentlyBuilding:MovieClip;
		private var _selectedItemRange:BuildModeRangeOverlay;
		
		// Tutorial
		private var tutorial:TutorialGoals;
		private var ingameTutorial:TutorialIngameElements;
		
		
		public function GameScreen(level:Number) {			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,false,0,true);
			
			_level = level;
			_isMouseUp = true;
			
			if (ActiveGameScreenInstances != 0) throw new Error("Multiple game instances active! That doesn't make sense!");
		}
		public override function destroy():void
		{
			--ActiveGameScreenInstances;
			
			removeChild(shopScreen);
			shopScreen = null;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseLeftDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseLeftUp);
			
			if(_mapLoader.hasEventListener(Event.COMPLETE)) 
				_mapLoader.removeEventListener(Event.COMPLETE, mapDoneLoading);
				
			if(hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				
			if(_player.hasEventListener(WeaponEvent.BULLET_SHOT))		
				_player.removeEventListener(WeaponEvent.BULLET_SHOT, onAddBullet);
				
			if(gameTimer.hasEventListener(TimerEvent.TIMER))
				gameTimer.removeEventListener(TimerEvent.TIMER, onTick);
				
			if(InputEventCannon.mainInstance.hasEventListener(InputEvents.PAUSE_GAME))	
				InputEventCannon.mainInstance.removeEventListener(InputEvents.PAUSE_GAME, onPauseGame);
				
			if(InputEventCannon.mainInstance.hasEventListener(InputEvents.RESUME_GAME))
				InputEventCannon.mainInstance.removeEventListener(InputEvents.RESUME_GAME, onResumeGame);
			
			if(InputEventCannon.mainInstance.hasEventListener(InputEvents.OPEN_OPTIONS))
			{
				if(optionsMenuScreen==null)
					InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, onOpenOptions);
				else
					optionsMenuScreen.removeEventListener(InputEvents.OPEN_OPTIONS,onCloseOptions);
				
			}
				
			if(InputEventCannon.mainInstance.hasEventListener(InputEvents.PLAYER_TOGGLE_BUILD_MODE))
				InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_TOGGLE_BUILD_MODE, onToggleBuildMode);
				
			UI.buildButton.removeEventListener(MouseEvent.CLICK, onToggleBuildMode);
			
			if(_player.inventory.hasEventListener(InventoryEvent.SELECTED_WEAPON_CHANGED))
				_player.inventory.removeEventListener(InventoryEvent.SELECTED_WEAPON_CHANGED, onChangedWeapon);
				
			if(InputEventCannon.mainInstance.hasEventListener(InputEvents.OPEN_SHOP))
			{
				if(shopScreen.visible)
					InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_SHOP, onRemoveShop);
				else
					InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_SHOP, onOpenShop);
			}
			
			UI.shopButton.removeEventListener(MouseEvent.CLICK, onShopButtonClick);
			UI.menuButton.removeEventListener(MouseEvent.CLICK, onMenuButtonClick);
			
			if (InputEventCannon.mainInstance.hasEventListener(TutorialEvent.COMPLETED_ACTION))
			{
				InputEventCannon.mainInstance.removeEventListener(
					TutorialEvent.COMPLETED_ACTION, tutorialEventComplete);
			}
			
			if (InputEventCannon.mainInstance.hasEventListener(InputEvents.GAME_LOST_FOCUS))
			{
				InputEventCannon.mainInstance.removeEventListener(InputEvents.GAME_LOST_FOCUS, gameLostFocus);
			}
			
			if (_mapLoader.hasEventListener(MapLoadEvent.LOADING_PROGRESS))
			{
				_mapLoader.removeEventListener(MapLoadEvent.LOADING_PROGRESS, mapLoadProgress);
			}
			
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_DOWN_PRESS, playerDownPress);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_LEFT_PRESS, playerLeftPress);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_UP_PRESS, playerUpPress);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_RIGHT_PRESS, playerRightPress);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_DOWN_RELEASE, playerDownRelease);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_LEFT_RELEASE, playerLeftRelease);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_UP_RELEASE, playerUpRelease);
			InputEventCannon.mainInstance.removeEventListener(InputEvents.PLAYER_RIGHT_RELEASE, playerRightRelease);
			
			InputEventCannon.mainInstance.setMouseOnShop(false);
		}
		
		private function mapLoadProgress(e:MapLoadEvent):void
		{
			progressMessage.text = e.loadingProgress;
		}
		
		private function onAddedToStage(e:Event):void
		{
			if (ActiveGameScreenInstances != 0) throw new Error("Multiple game instances active! That doesn't make sense!");
			++ActiveGameScreenInstances;
			stage.focus=stage;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Load the game layers
			effectsLayer = new MovieClip();
			_entitiesLayer = new MovieClip();
			_buildModeLayer = new MovieClip();
			Map.effectsContainer = effectsLayer;
			Map.entitiesContainer = _entitiesLayer;
			
			// Load the map
			_mapLoader = new MapLoader();
			_mapLoader.addEventListener(MapLoadEvent.LOADING_PROGRESS, mapLoadProgress, false, 0, true);
			_mapLoader.loadMap(_level);
			_mapLoader.addEventListener(Event.COMPLETE, mapDoneLoading,false,0,true);
		}
		
		private function mapDoneLoading(e:Event):void
		{
			_mapLoader.removeEventListener(Event.COMPLETE, mapDoneLoading);
			
			InputEventCannon.mainInstance.setMouseOnShop(false);
			
			// Create the map
			_map = _mapLoader.getMap();
			addChild(_map);
			_map.draw();
			
			// Load the player
			_player = new Player();
			_entitiesLayer.addChild(_player);
			var playerSpawn:Point = _map.getCenterOfTile(_map.getPlayerSpawningTile());
			_player.x = playerSpawn.x;
			_player.y = playerSpawn.y;
			_playerWantsAutomaticShoot = false;
			_bullets = new Array();
			_player.addEventListener(WeaponEvent.BULLET_SHOT, onAddBullet,false,0,true);
			_levelResourceGoals = new LevelResourceGoals();
			_levelStartInventory = new LevelStartingInventory();
			_moveInputLastUp = new Dictionary();
			
			// Load enemies
			_enemies = new Array();
			_spawner = new ZombieSpawner(_map, _level);
			
			//add pause menu
			InputEventCannon.mainInstance.addEventListener(InputEvents.PAUSE_GAME, onPauseGame,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.RESUME_GAME, onResumeGame,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, onOpenOptions,false,0,true);
			
			//add shop
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_SHOP, onOpenShop,false,0,true);
			
			// Load the tutorial objects
			tutorial = new TutorialGoals();
			ingameTutorial = new TutorialIngameElements();
			
			//add UI
			UI=new GameUI(_player.inventory, _level,
						  _levelResourceGoals.getResourcesForWin(_level),
						  _levelResourceGoals.getKillsForWin(_level));
			UI.addEventListener(Event.ADDED_TO_STAGE, UIready, false, 0, true);
			_underUI = new MovieClip();
			addChild(_underUI);
			addChild(UI);
			
			UI.shopButton.addEventListener(MouseEvent.CLICK, onShopButtonClick,false,0,true);
			UI.menuButton.addEventListener(MouseEvent.CLICK, onMenuButtonClick,false,0,true);
			
			// build UI
			shopScreen = new ShopMenuScreen(_player.inventory, _level);
			shopScreen.y += UI.tutorialText.height;
			shopScreen.visible = false;
			
			_selectedTile = new BuildModeTileSelectionOverlay();
			_selectedItemRange = new BuildModeRangeOverlay();
			_currentlyBuilding = new MovieClip();
			_buildableTilesContainer = new MovieClip();
			
			_currentlyBuilding.alpha = CURRENTLY_BUILDING_ITEM_ALPHA;
			
			_map.addChild(_buildModeLayer);
			_buildModeLayer.addChild(_buildableTilesContainer);
			_buildModeLayer.addChild(_currentlyBuilding);
			_buildModeLayer.addChild(_selectedTile);
			
			setBuildMode(false);
			_buildModeLayer.addChild(_selectedItemRange);
			
			// build mode event
			InputEventCannon.mainInstance.addEventListener(
				InputEvents.PLAYER_TOGGLE_BUILD_MODE, onToggleBuildMode,false,0,true);
			UI.buildButton.addEventListener(MouseEvent.CLICK, onToggleBuildMode,false,0,true)
				
			// starting weapon
			_player.inventory.acquireWeapon(Inventory.KNIFE_WEAPON);
			
			_levelStartInventory.fillInventoryForLevel(_player.inventory, _level);
			
			//TOREMOVE TODO: Buy other weapons instead
			//_player.inventory.acquireWeapon(Inventory.HANDGUN_WEAPON);
			//_player.inventory.acquireWeapon(Inventory.MACHINE_GUN_WEAPON);
			//_player.inventory.acquireWeapon(Inventory.SHOTGUN_WEAPON);
			//_player.inventory.acquireWeapon(Inventory.SNIPER_WEAPON);
			//_player.inventory.acquireWeapon(Inventory.FIRE_WAVE);
			
			// TOREMOVE
			// TODO: Gather the resources instead
			//_player.inventory.collectResource(Inventory.BASE_RESOURCE, 400);
			//_player.inventory.collectResource(Inventory.TECH_RESOURCE, 200);
			//_player.inventory.collectResource(Inventory.PROGRESS_RESOURCE, 5);
				
			// TOREMOVE
			// TODO: Buy the items instead
			
			//_player.inventory.addObject(Inventory.ROCK_WALL, 5);
			//_player.inventory.addObject(Inventory.BRICK_WALL, 3);
			//_player.inventory.addObject(Inventory.AUTO_TURRET, 99);
			//_player.inventory.addObject(Inventory.SPIKE_TRAP, 4);
			//_player.inventory.addObject(Inventory.PROD_BOOSTER, 2);
			//_player.inventory.addObject(Inventory.PROGRESS_RESOURCE, 5);
			
			
			// TOREMOVE
			// TODO: Buy ammo
			_player.inventory.collectAmmo(Inventory.AMMO, START_AMMO_AMOUNT);
			//_player.inventory.collectAmmo(Inventory.AMMO2, 1000);
			
			// TOREMOVE
			// Used when you want a lot of resources to test stuff
			//_player.inventory.collectResources(CostDB.CostFor(Inventory.AUTO_TURRET), 100);
			
			// We wait for the inventory change of weapon
			_player.inventory.addEventListener(InventoryEvent.SELECTED_WEAPON_CHANGED, onChangedWeapon,false,0,true);
			
			// Input events
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseLeftDown,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseLeftUp,false,0,true);	
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_DOWN_PRESS, playerDownPress,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_LEFT_PRESS, playerLeftPress,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_UP_PRESS, playerUpPress,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_RIGHT_PRESS, playerRightPress,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_DOWN_RELEASE, playerDownRelease,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_LEFT_RELEASE, playerLeftRelease,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_UP_RELEASE, playerUpRelease,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.PLAYER_RIGHT_RELEASE, playerRightRelease,false,0,true);
			
			// load the game objects
			gameTimer = new Timer(MILLISECS_PER_FRAME);
			gameTimer.addEventListener(TimerEvent.TIMER, onTick,false,0,true);
			gameTimer.start();
			_isPaused = false;
			
			// We add an event for the completion of a tutorial.
			InputEventCannon.mainInstance.addEventListener(
					TutorialEvent.COMPLETED_ACTION, tutorialEventComplete);
					
			// When the game loses focus, we open the pause menu
			InputEventCannon.mainInstance.addEventListener(InputEvents.GAME_LOST_FOCUS, gameLostFocus,
														   false, 0, true);
														   
			stage.focus = stage;			
			
			InputEventCannon.mainInstance.unpause();
		}
		private function UIready(e:Event):void
		{
			UI.removeEventListener(Event.ADDED_TO_STAGE, UIready);
			updateTutorialText(); // draw the first tutorial element if we should
		}
		private function updateTutorialText():void
		{
			UI.setTutorialSteps(tutorial.getTutorialSteps(_level));
		}
		private function onPauseGame(e:InputEvents):void
		{
			_isPaused = true;
		}
		private function onResumeGame(e:InputEvents):void
		{
			_isPaused = false;
		}
		private function spawnZombie(tile:Tile):void
		{
			var zombie:Zombie = new Zombie(_map);
			zombie.x = _map.getCenterOfTile(tile).x;
			zombie.y = _map.getCenterOfTile(tile).y;
			
			_entitiesLayer.addChild(zombie);
			_enemies.push(zombie);
		}
		private function onChangedWeapon(e:InventoryEvent):void
		{
			_player.changeCurrentWeapon(_player.inventory.getSelectedWeapon());
		}
		
		private function onTick(timerEvent:TimerEvent):void
		{
			if (!_isPaused)
			{
				++FrameCount;
				
				InputEventCannon.mainInstance.dispatchEvent(new Event(InputEventCannon.UPDATE));
				
				// update the player
				updatePlayer();
				
				// update the zombies
				updateZombies();
				
				// update the camera
				_map.updateCamera(_player);
				
				// update the map
				_map.updateMapObjects(_player, _enemies);
				
				// Check to build
				updateBuildMode();
				
				// update bullets
				updateBullets();
				
				// updates the ingame tutorial using the game objects
				ingameTutorial.updateTutorial(tutorial.getCurrentTutorialStep(_level), this, _player,
										  _map, _enemies, UI);
										  
				if (shopScreen.visible) shopScreen.onTick();
			}
		}
		
		private function updateZombies():void
		{
			// Check to spawn a new zombie
			if (_spawner.shouldSpawn() && _enemies.length < MAX_ZOMBIES) 
				spawnZombie(_spawner.getSpawnTile());
			
			for each (var zombie:Zombie in _enemies)
			{
				if (!zombie.isDead())
					updateZombie(zombie);
					
				// check for melee damage
				if (_player.isMeleeHurtingEntity(zombie)) 
					hurtZombie(zombie, _player.getWeaponDamage(), _player);
			}
			
			// Kill the zombies that died
			for each (var maybeDeadZombie:Zombie in _enemies)
			{
				if (maybeDeadZombie.shouldBeKilled())
				{
					// Remove the zombie
					_enemies.splice(_enemies.indexOf(maybeDeadZombie), 1);
					_entitiesLayer.removeChild(maybeDeadZombie);
					maybeDeadZombie = null;
					_player.inventory.collectResource(Inventory.KILL_RESOURCE, 1);
				}
			}
		}
		
		private function updateBullets():void
		{
			// Update the bullets
			for each (var bullet:Bullet in _bullets)
			{
				// Check to hurt zombies
				for each (var zombie:Zombie in _enemies)
				{
					if (!zombie.isDead() && zombie.getBounds(zombie.parent).containsPoint(new Point(bullet.x, bullet.y)))
					{
						hurtZombie(zombie, bullet.getDamage(), bullet.source);
						
						if (!bullet.isPenetrable())
						{
							bullet.killMe();
							break;
						}
					}
				}
				
				// Kill the bullets that collide with terrain / objects
				if (_map.collidesWithSolidAndNotPenetrable(bullet.x, bullet.y))
				{
					bullet.killMe();
				}
				
				
				if (!bullet.shouldBeKilled())
				{
					bullet.move();
				}
			}
			// Kill the bullets that collided
			for each (var bulletShot:Bullet in _bullets)
			{
				if (bulletShot.shouldBeKilled())
				{
					// Remove the bullet
					bulletShot.onDestroy();
					bulletShot.removeEventListener(WeaponEvent.BULLET_SHOT, createExplosion);
					_bullets.splice(_bullets.indexOf(bulletShot), 1);
					_map.removeChild(bulletShot);
					bulletShot = null;
				}
			}
		}
		private function createExplosion(e:WeaponEvent):void
		{
			var explosion:FireWaveMapObject = new FireWaveMapObject();
			explosion.x = e.bulletStartX;
			explosion.y = e.bulletStartY;
			
			_map.addEffect(explosion);
		}
		private function hurtZombie(zombie:Zombie, damage:Number, source:WorldObject):void
		{
			zombie.ai.onAttacked(source);
			zombie.hurt(damage);
		}
		
		private function onAddBullet(e:WeaponEvent):void
		{
			var startX:Number = e.parentStartX + e.bulletStartX;
			var startY:Number = e.parentStartY + e.bulletStartY;
			
			var bullet:Bullet = new e.bulletType(e.bulletSource);
			bullet.x = startX;
			bullet.y = startY;
			bullet.rotationZ = e.orientationDegrees;
				
			_map.addChild(bullet);
			_bullets.push(bullet);
			
			bullet.addEventListener(WeaponEvent.BULLET_SHOT, createExplosion, false,0,true);
			
			// If it's a bullet, it makes sound to pull zombies that are around
			if (e.bulletType == NormalBullet ||
				e.bulletType == HighBullet)
			{
				const ZOMBIE_HEAR_DISTANCE:Number = Map.TILE_H * 4;
				const ZOMBIE_HEAR_DISTANCE_SQUARED:Number = ZOMBIE_HEAR_DISTANCE * ZOMBIE_HEAR_DISTANCE;
				
				for each (var zombie:Zombie in _enemies)
				{
					// Close enough?
					if (zombie.ai.target == null && // not targetting a thing
						Math.pow(zombie.x - _player.x, 2) + Math.pow(zombie.y - _player.y, 2)
						<= ZOMBIE_HEAR_DISTANCE_SQUARED)
					{
						// Chase the shooter (player or turret)
						zombie.ai.tryTarget(e.bulletSource);
					}
				}
			}
		}
		
		private function updateBuildMode():void
		{
			UI.buildButton.enabled = !_player.inventory.isEmpty();
			
			// Update the circle that shows the range of an object while building it.
			if (_selectedItemRange != null)
			{
				_selectedItemRange.visible = _buildMode && !_player.inventory.isEmpty() &&
					(_player.inventory.getSelectedItemName() == Inventory.PROD_BOOSTER ||
					 _player.inventory.getSelectedItemName() == Inventory.AUTO_TURRET);
				if (_selectedItemRange.visible)
				{
					_selectedItemRange.width = _selectedItemRange.height = 
						_player.inventory.getSelectedItemName() == Inventory.PROD_BOOSTER ?
						ProductivityBoosterMapObject.MAX_DISTANCE * 2 :
						AutoTurretMapObject.RANGE * 2;
				}
			}
			
			// Update the object that shows the object that we are currently building
			if (_currentlyBuilding != null)
			{
				_currentlyBuilding.visible = _buildMode && !_player.inventory.isEmpty();
				if (_currentlyBuilding.visible)
				{
					// If we chose a different item
					if (_currentlyBuilding.numChildren == 0 ||
						_currentlyBuilding.getChildAt(0) != _player.inventory.getSelectedWorldObject())
					{
						// Then we change the selected one image
						if (_currentlyBuilding.numChildren > 0) _currentlyBuilding.removeChildAt(0);
						_currentlyBuilding.addChildAt(_player.inventory.getSelectedWorldObject(), 0);
					}
				}
			}
			
			// Are we building?
			_buildableTilesContainer.visible = _buildMode; // only show the buildable tiles if we're building
			
			if (_buildMode)
			{
				_selectedTile.tile = _map.getTileUnderMouse();
				
				// Show the buildable tiles around the player
				var buildable:Array = _map.getBuildableTilesAround(_player, _enemies);
				if (buildable != _buildableTiles) // do we have new buildable tiles to show?
				{
					// If so, we have to clean the old ones
					for (var i:Number = _buildableTilesContainer.numChildren - 1; i >= 0; --i)
					{
						_buildableTilesContainer.removeChildAt(i);
					}
					_buildableTiles = new Array(); // reset our array
					
					// Add the new ones
					_buildableTiles = buildable;
					for each (var tile:Tile in _buildableTiles)
					{
						var overlay:BuildModeTileSelectionOverlay = new BuildModeTileSelectionOverlay();
						overlay.x = tile.x;
						overlay.y = tile.y;
						overlay.setTileIsValid(true); // these are all valid tiles
						
						_buildableTilesContainer.addChild(overlay);
					}
				}
				
				// If we're targetting a valid tile
				if (_selectedTile.tile != null)
				{
					_selectedTile.x = _selectedTile.tile.x;
					_selectedTile.y = _selectedTile.tile.y;
					
					var tileCenter:Point = _map.getCenterOfTile(_selectedTile.tile);
					_selectedItemRange.x = tileCenter.x;
					_selectedItemRange.y = tileCenter.y;
					
					_currentlyBuilding.x = tileCenter.x;
					_currentlyBuilding.y = tileCenter.y;
					
					var valid:Boolean = _map.canBuildOn(_selectedTile.tile, _player, _enemies);
					_selectedTile.setTileIsValid(valid);
					_selectedItemRange.setTileIsValid(valid);
				}
				
				// continuous building: mouse down makes you build
				if (!_isMouseUp && InputEventCannon.mainInstance.wantsToKeepBuilding()) 
					tryBuild();
			}
		}
		
		private function updatePlayer():void
		{
			if (_player.shouldBeKilled()) gameOver();
			
			_player.updateWeapon();
			
			// Check if we want to move left/right/up/down
			if (InputEventCannon.mainInstance.isPlayerMoveLeft())
				_player.move(-Player.MOVE_AS_FAST_AS_POSSIBLE, 0);
			if (InputEventCannon.mainInstance.isPlayerMoveRight())
				_player.move(Player.MOVE_AS_FAST_AS_POSSIBLE, 0);
			if (InputEventCannon.mainInstance.isPlayerMoveUp())
				_player.move(0, -Player.MOVE_AS_FAST_AS_POSSIBLE);
			if (InputEventCannon.mainInstance.isPlayerMoveDown())
				_player.move(0, Player.MOVE_AS_FAST_AS_POSSIBLE);
				
			_player.updateSprint();
				
			// apply that movement
			_player.applyMove();
			
			// undo collisions that we created while moving
			_map.undoCollisions(_player); 
			
			// aim at the mouse (projected in the world)
			_player.lookAt(_map.camera.screenToWorldCoords(new Point(mouseX, mouseY))); 
			
			// shoot automatic weapons if we should
			if (_playerWantsAutomaticShoot) _player.automaticAttack();
			
			// check for win conditions
			if (_levelResourceGoals.hasWon(_player.inventory, _level))
			{
				gameWin(); // we won the level
			}
			
			// check to auto-heal
			_timeSinceLastLifeRegen += GameScreen.MILLISECS_PER_FRAME;
			if (_timeSinceLastLifeRegen > MILLISECONDS_FOR_LIFE_REGEN)
			{
				_player.heal(LIFE_REGEN_AMOUNT);
				_timeSinceLastLifeRegen = 0;
			}
		}
		private function gameWin():void
		{
			if (levelEndAnim == null)
			{
				levelEndAnim = new LevelEndAnimation(_level, true);
				addChild(levelEndAnim);
			}
			
		}
		
		private function tutorialEventComplete(e:TutorialEvent):void
		{
			tutorial.markAsCompleted(_level, e.actionCompleted);
			updateTutorialText();
		}
		
		private function gameOver():void
		{
			if (levelEndAnim == null)
			{
				levelEndAnim = new LevelEndAnimation(_level, false);
				addChild(levelEndAnim);
			}
		}
		
		private function updateZombie(zombie:Zombie):void
		{
			var movePt:Point = zombie.ai.getMove(_map, _player);
			
			zombie.move(movePt.x, movePt.y);
			zombie.updateSlowdown();
			
			var stopMovement:Boolean = false;
			
			// Check to hit the player
			if (zombieCheckToHit(zombie, _player)) 
			{
				stopMovement = true;
				_timeSinceLastLifeRegen = 0; // stop life regeneration when the player gets hit.
			}
			
			// Check to hit destroyable objects
			for each (var destroyable:LivingWorldObject in _map.getDestroyableObjects())
			{
				if (zombieCheckToHit(zombie, destroyable)) stopMovement = true;
				// remove broken objects
				if (destroyable.isDead()) destroyable.killMe(); 
			}
			
			// Check to capture ressources
			for each (var resource:MapResource in _map.getResourceObjects())
			{
				if (zombieCheckToHit(zombie, resource)) stopMovement = true;
			}
			
			if (stopMovement) 
			{
				zombie.dontMove();
				// look at our target if we should
				if (zombie.ai.target != null) zombie.lookAt(new Point(zombie.ai.target.x, zombie.ai.target.y));
			}
			
			if (!zombie.isAttacking()) // only move when we should
			{
				// apply that movement
				zombie.applyMove();
			}
			
			// undo collisions that we created from the movement
			_map.undoCollisions(zombie);
		}
		
		private function zombieCheckToHit(zombie:Zombie, obj:WorldObject):Boolean
		{
			if (zombie.ai.target == obj && // that's our target
				Point.distance(new Point(zombie.x, zombie.y), new Point(obj.x, obj.y)) // we're close enough
				- obj.getHitDistance() / 2 <= Zombie.ATTACK_RANGE)
			{
				// We're hurting something
				if (obj is LivingWorldObject)
					zombie.attack(obj as LivingWorldObject);
					
				// We're capturing a resource
				else if (obj is MapResource)
				{
					(obj as MapResource).onZombieCollision();
					if ((obj as MapResource).isOwnedByZombie()) zombie.ai.resetTarget(); // stop targeting if we captured the ressource
				}
				
				// We're in collision with something we're not supposed to be colliding with.
				else throw new Error("Object \"" + (obj as Class).toString() + 
									 "\" is not implemented for zombie-collision.");
				
				return true; // we did hit something
			}
			
			return false; // we didn't hit an object
		}
		
		private function setBuildMode(build:Boolean):void
		{
			if (build && // if we want to start building
				_player.inventory.isEmpty()) // but we can't
				build = false; // prevent building.
			
			_buildMode = build;
			_selectedTile.visible = _buildMode;
			updateBuildMode(); // show the overlay at the right place right away
			
			// Check to update the tutorial about going into build mode
			if (_buildMode)
			{
				Tutorial.onDone(TutorialGoals.PLACE_WALL_BUILD_MODE);
				Tutorial.onDone(TutorialGoals.UNBUILDABLE_TILES_BUILD_MODE);
			}
		}
		
		private function onToggleBuildMode(e:Event):void
		{
			setBuildMode(!_buildMode);
		}
		
		private function onMouseLeftDown(e:MouseEvent):void
		{
			if (!_isPaused)
			{
				_isMouseUp = false;
				if (!InputEventCannon.mainInstance.isFocusOnShop()) // if game is focused
				{
					if (!_buildMode) // not building: we shoot
					{
						// We don't shoot if we just clicked on something that is not meant to be shot at (e.g. click on UI)
						var mousePosOnGame:Point = _map.camera.worldToScreenCoords(
							new Point(_map.mouseX, _map.mouseY - GameUI.MAP_START_Y));
						if (mousePosOnGame.x > 0 && mousePosOnGame.y > 0 &&
							mousePosOnGame.x <= DocumentClass.SCREEN_W && 
							mousePosOnGame.y <= DocumentClass.SCREEN_H)
						{
							_playerWantsAutomaticShoot = true;
							_player.attack();
						}
					}
				}
			}
		}
		
		private function onMouseLeftUp(e:MouseEvent):void
		{
			if (!_isPaused)
			{
				_isMouseUp = true;
				if (!InputEventCannon.mainInstance.isFocusOnShop()) // if game is focused
				{
					_playerWantsAutomaticShoot = false;
					if (_buildMode) // we want to build the selected item
					{
						tryBuild();
					}
				}
			}
		}
		
		private function tryBuild():void
		{
			if (_selectedTile.ValidTile)
			{
				// Check to update the tutorial about building stuff
				if (_player.inventory.getSelectedItemName() == Inventory.ROCK_WALL)
					Tutorial.onDone(TutorialGoals.PLACE_WALL_BUILD);
				else if (_player.inventory.getSelectedItemName() == Inventory.BRICK_WALL)
					Tutorial.onDone(TutorialGoals.PLACE_BARRIER_BUILD_IT);
				else if (_player.inventory.getSelectedItemName() == Inventory.PROGRESS_RESOURCE)
					Tutorial.onDone(TutorialGoals.CONTROL_PROGRESS_BUILD_IT);
				else if (_player.inventory.getSelectedItemName() == Inventory.SPIKE_TRAP ||
						 _player.inventory.getSelectedItemName() == Inventory.AUTO_TURRET)
					Tutorial.onDone(TutorialGoals.PLACE_TIER2_ITEMS_BUILD);
				
				_map.addMapObject(_player.inventory.getSelectedWorldObject(), 
								  _selectedTile.tile);
				_player.inventory.useSelectedWorldObject();
				
				// If we don't want to keep building, go out of the build mode
				if (!InputEventCannon.mainInstance.wantsToKeepBuilding() ||
					_player.inventory.isEmpty())
					setBuildMode(false);
			}
		}
		
		private function playerDownPress(e:InputEvents):void
		{
			tryStartSprint(Keyboard.DOWN);
		}
		private function playerUpPress(e:InputEvents):void
		{
			tryStartSprint(Keyboard.UP);
		}
		private function playerLeftPress(e:InputEvents):void
		{
			tryStartSprint(Keyboard.LEFT);
		}
		private function playerRightPress(e:InputEvents):void
		{
			tryStartSprint(Keyboard.RIGHT);
		}
		private function tryStartSprint(key:uint):void
		{
			if (key == lastMoveKeyReleased) // and we double-tapped a key
			{
				if ((GameScreen.FrameCount - _moveInputLastUp[key]) * MILLISECS_PER_FRAME <= TIME_FOR_KEY_DOUBLETAP_MILLISECS)
				{
					_player.sprinting = true;
				}
			}
			lastMoveKeyReleased = key;
		}
		private function playerDownRelease(e:InputEvents):void
		{
			updateMoveInputKeyRelease(Keyboard.DOWN);
		}
		private function playerUpRelease(e:InputEvents):void
		{
			updateMoveInputKeyRelease(Keyboard.UP);
		}
		private function playerLeftRelease(e:InputEvents):void
		{
			updateMoveInputKeyRelease(Keyboard.LEFT);
		}
		private function playerRightRelease(e:InputEvents):void
		{
			updateMoveInputKeyRelease(Keyboard.RIGHT);
		}
		
		private function updateMoveInputKeyRelease(key:uint):void
		{
			// Store the frame at which we released the key, to check if we are double-tapping a key
			_moveInputLastUp[key] = GameScreen.FrameCount;
			lastMoveKeyReleased = key;
		}
		
		public function addUIElement(elem:MovieClip):void
		{
			UI.addChild(elem);
		}
		
		public function removeUIElement(elem:MovieClip):void
		{
			UI.removeChild(elem);
		}
		public function isBuildMode():Boolean
		{
			return _buildMode;
		}
		
		private function gameLostFocus(e:InputEvents):void
		{
			// We decided not to pause the game when it loses the focus
		}
		private function onOpenShop(e:InputEvents):void
		{
			if(!_isPaused)
			{
				InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_SHOP, onOpenShop);
				
				shopScreen.visible = true;
				
				_underUI.addChild(shopScreen);
				
				Tutorial.onDone(TutorialGoals.BUY_GUN_OPEN_SHOP);
				Tutorial.onDone(TutorialGoals.BUY_AMMO_OPEN_SHOP);
				Tutorial.onDone(TutorialGoals.BUY_TIER2_WEAPON_OPEN_SHOP);
				
				InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_SHOP, onRemoveShop);
			}
		}
		private function onRemoveShop(e:InputEvents):void
		{
			InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_SHOP, onRemoveShop);
			
			InputEventCannon.mainInstance.setMouseOnShop(false);
			
			shopScreen.visible = false;
			
			if (stage != null) stage.focus = stage;
			
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_SHOP, onOpenShop);
		}
		private function onOpenOptions(e:InputEvents):void
		{
			if (_buildMode) // if we're building cancel the building process
			{
				setBuildMode(false);
			}
				
			else if(shopScreen.visible) // otherwise if we're shopping, close the shop
			{
				onRemoveShop(null);
			}
			
			else if (optionsMenuScreen == null) // if everything else is closed, open the options menu
			{
				InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, onOpenOptions);
				
				InputEventCannon.mainInstance.setMouseOnShop(true);
				
				optionsMenuScreen= new OptionsMenuScreen(true);			
				optionsMenuScreen.addEventListener(InputEvents.OPEN_OPTIONS,onCloseOptions);
				
				addChild(optionsMenuScreen);
				
				//PerformanceProfiler.show(); // Uncomment this line if you want to show th profiler results
			}
		}
		private function onCloseOptions(e:Event):void
		{
			optionsMenuScreen.removeEventListener(InputEvents.OPEN_OPTIONS,onCloseOptions);
			removeChild(optionsMenuScreen);
			optionsMenuScreen=null;
			
			InputEventCannon.mainInstance.setMouseOnShop(false);
			
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, onOpenOptions);
			if (stage != null) stage.focus=stage;
		}
		private function onShopButtonClick(e:MouseEvent):void
		{
			if (!shopScreen.visible)
				onOpenShop(null);
			else
				onRemoveShop(null);
		}
		private function onMenuButtonClick(e:MouseEvent):void
		{
			if (optionsMenuScreen == null)
				onOpenOptions(null);
			else
				onCloseOptions(null);
		}
	}	
}
