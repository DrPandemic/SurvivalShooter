package  {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;
	import flash.display.DisplayObject;
	
	public class TutorialIngameElements {
		private var currentStep:String;
		private var currentElements:Array;
		private var changedStep:Boolean;
		
		private var oldResourcesCount:Number;
		private var oldWallsCount:Number;
		private var walls:Array;
		private var resources:Array;

		public function TutorialIngameElements() {
			changedStep = false;
			currentStep = null;
			resources = null;
			walls = null;
			currentElements = new Array();
			oldResourcesCount = 0;
			oldWallsCount = 0;
		}
		
		public function updateTutorial(newStep:String, gameScreen:GameScreen,
									   player:Player, map:Map, enemies:Array,
									   ui:GameUI):void
		{
			if (newStep != currentStep) // if something changed
			{
				if (currentElements.length != 0)
				{
					clearElements(gameScreen);
				}
				
				changedStep = true;
				
				currentStep = newStep;
				
				if (newStep == null || newStep == "") return;
				
				var theClass:Class = getClassForTutorialStep(currentStep);
				if (theClass != null) // if we have something to show
				{
					var element:MovieClip = new theClass();
					gameScreen.addUIElement(element);
					currentElements.push(element);
				}
				else
					currentElements = new Array();
			}
			else 
				changedStep = false;
			
			if (newStep == null || newStep == "") return;
			placeElementAccordingToStep(currentStep, gameScreen, player, map, enemies, ui);
		}

		private function getClassForTutorialStep(step:String):Class
		{
			switch (step)
			{
				case TutorialGoals.MOVE_WALK:
					return TutorialDisplayPlayerMove as Class;
					
					
					
				case TutorialGoals.MOVE_RUN:
					return TutorialDisplayPlayerRun as Class;
					
					
					
				case TutorialGoals.ATTACK_KNIFE:
				case TutorialGoals.PLACE_WALL_BUILD:
					return TutorialDisplayPlayerAttack as Class;
					
					
					
				case TutorialGoals.CONTROL_BASE_RESOURCE_STEP_OVER_RESOURCE:
				case TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_CONTROL_RESOURCE:
				
				case TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_FOR_ENOUGH_RESOURCES_FOR_GUN:
				case TutorialGoals.BUY_GUN_CLICK_HANDGUN:
				case TutorialGoals.BUY_GUN_CLICK_BUY:
				
				case TutorialGoals.SELECT_GUN_CHANGE_IT:
				
				case TutorialGoals.PLACE_WALL_SEE_TOOLTIP:
				case TutorialGoals.PLACE_WALL_BUILD_MODE:
				
				case TutorialGoals.HURT_WALL_HIT_WALL:
				
				case TutorialGoals.BUY_AMMO_CLICK_AMMO:
				case TutorialGoals.BUY_AMMO_BUY_AMMO:
				
				case TutorialGoals.CONTROL_TECH_STEP_OVER_RESOURCE:
				case TutorialGoals.CONTROL_TECH_WAIT_CONTROL_RESOURCE:
				
				case TutorialGoals.DEFEND_COLLECT_ENOUGH_PROGRESS:
				
				case TutorialGoals.UNBUILDABLE_TILES_BUILD_MODE:
					return TutorialDisplayCircleTile as Class;
					
					
					
				case TutorialGoals.BUY_GUN_OPEN_SHOP:
				case TutorialGoals.BUY_AMMO_OPEN_SHOP:
				
				case TutorialGoals.PLACE_BARRIER_SELECT_IT:
				case TutorialGoals.PLACE_BARRIER_BUILD_IT:
				
				
				
				case TutorialGoals.BUY_TIER2_WEAPON_OPEN_SHOP:
				case TutorialGoals.BUY_TIER2_WEAPON_SELECT_WEAPON:
				case TutorialGoals.BUY_TIER2_WEAPON_BUY_IT:
				
				case TutorialGoals.CONTROL_PROGRESS_WAIT_FOR_ENOUGH:
				case TutorialGoals.CONTROL_PROGRESS_BUILD_IT:
				
				case TutorialGoals.BUY_SNIPER_BUY_IT:
				case TutorialGoals.BUY_SNIPER_BUY_AMMO:
				
				case TutorialGoals.PLACE_TIER2_ITEMS_BUILD:
				
				case TutorialGoals.GRENADE_BUY:
				case TutorialGoals.GRENADE_SHOOT:
					return TutorialDisplayCircleUIButton as Class;
					
					
				default:
					throw new Error("The tutorial step has no ingame element referred to it. Return null if none should be displayed.");
			}
		}
		
		private function clearElements(gameScreen:GameScreen):void
		{
			for each (var currentElement:MovieClip in currentElements)
			{
				gameScreen.removeUIElement(currentElement);
			}
			currentElements = new Array();
		}
		
		private function placeElementAccordingToStep(step:String, gameScreen:GameScreen,
													 player:Player, map:Map, enemies:Array,
									   				 ui:GameUI):void
		{
			var screenCoords:Point;
			switch (step)
			{
				case TutorialGoals.MOVE_WALK:
				case TutorialGoals.MOVE_RUN:
				case TutorialGoals.ATTACK_KNIFE:
					placeElementFollowPlayer(player, map);
					break;
					
				case TutorialGoals.PLACE_WALL_BUILD:
					placeElementFollowPlayer(player, map);
					currentElements[0].visible = gameScreen.isBuildMode();
					break;
					
				case TutorialGoals.CONTROL_BASE_RESOURCE_STEP_OVER_RESOURCE:
				case TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_CONTROL_RESOURCE:
					placeElementsOnResources(Inventory.BASE_RESOURCE, step, map, gameScreen);
					break;
					
				case TutorialGoals.CONTROL_TECH_STEP_OVER_RESOURCE:
				case TutorialGoals.CONTROL_TECH_WAIT_CONTROL_RESOURCE:
					placeElementsOnResources(Inventory.TECH_RESOURCE, step, map, gameScreen);
					break;
					
				case TutorialGoals.DEFEND_COLLECT_ENOUGH_PROGRESS:
					placeElementsOnResources(Inventory.PROGRESS_RESOURCE, step, map, gameScreen);
					break;
					
				case TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_FOR_ENOUGH_RESOURCES_FOR_GUN:
					placeElementOnResourceAmountDisplay(ui.resource1);
					resources = null;
					oldResourcesCount = 0;
					break;
					
				case TutorialGoals.BUY_AMMO_OPEN_SHOP:
				case TutorialGoals.BUY_GUN_OPEN_SHOP:
				case TutorialGoals.BUY_TIER2_WEAPON_OPEN_SHOP:
					placeElementOnObject(ui.shopButton);
					break;
					
				case TutorialGoals.BUY_TIER2_WEAPON_SELECT_WEAPON:
					const TIER2_WEAPON_INDEX:Number = 1;
					const TIER2_WEAPON_COUNT:Number = 2;
					placeElementsOnConsecutiveShopIcons(TIER2_WEAPON_INDEX,
														TIER2_WEAPON_COUNT,
														step, gameScreen);
					break;
					
				case TutorialGoals.BUY_TIER2_WEAPON_BUY_IT:
					placeElementOnShopBuyIf(
						gameScreen.shopScreen.visible &&
							(gameScreen.shopScreen.getSelectedItem() == Inventory.MACHINE_GUN_WEAPON ||
							 gameScreen.shopScreen.getSelectedItem() == Inventory.SHOTGUN_WEAPON),
						gameScreen);
					break;
					
				case TutorialGoals.BUY_GUN_CLICK_HANDGUN:
					const GUN_INDEX:Number = 0;
					const GUN_COUNT:Number = 1;
					placeElementsOnConsecutiveShopIcons(GUN_INDEX, GUN_COUNT,
														step, gameScreen);
					break;
					
				case TutorialGoals.BUY_AMMO_CLICK_AMMO:
					const AMMO_START_INDEX:Number = 1;
					const AMMO_DEAL_COUNT:Number = 3;
					placeElementsOnConsecutiveShopIcons(AMMO_START_INDEX, AMMO_DEAL_COUNT,
														step, gameScreen);
					break;
					
				case TutorialGoals.BUY_AMMO_BUY_AMMO:
					placeElementOnShopBuyIf(
											gameScreen.shopScreen.visible && 
						(gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO_20 ||
						gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO_50 ||
						gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO_100),
						gameScreen);
					break;
					
				case TutorialGoals.GRENADE_BUY:
					placeElementOnShopBuyIf(gameScreen.shopScreen.visible &&
						gameScreen.shopScreen.getSelectedItem() == Inventory.FIRE_WAVE,
						gameScreen);
					break;
					
				case TutorialGoals.GRENADE_SHOOT:
					placeElementOnObject(ui.weapon6);
					break;
					
				case TutorialGoals.BUY_SNIPER_BUY_AMMO:
					placeElementOnShopBuyIf(gameScreen.shopScreen.visible &&
											(gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO2_20 ||
											 gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO2_50 ||
											 gameScreen.shopScreen.getSelectedItem() == Inventory.AMMO2_100),
											 gameScreen);
					break;
					
				case TutorialGoals.BUY_SNIPER_BUY_IT:
					placeElementOnShopBuyIf(gameScreen.shopScreen.visible &&
											gameScreen.shopScreen.getSelectedItem() == Inventory.SNIPER_WEAPON,
											gameScreen);
					break;
					
				case TutorialGoals.BUY_GUN_CLICK_BUY:
					placeElementOnShopBuyIf(gameScreen.shopScreen.visible &&
											gameScreen.shopScreen.getSelectedItem() == Inventory.HANDGUN_WEAPON,
											gameScreen);
					break;
					
				case TutorialGoals.SELECT_GUN_CHANGE_IT:
					placeElementOnObject(ui.weapon2);
					break;
					
				case TutorialGoals.PLACE_WALL_SEE_TOOLTIP:
					placeElementOnObject(ui.object1);
					break;
					
				case TutorialGoals.PLACE_TIER2_ITEMS_BUILD:
					const TIER2_ITEMS_COUNT:Number = 2;
					if (currentElements.length < TIER2_ITEMS_COUNT)
						addElement(step, gameScreen);
						
					placeElementOnObject(ui.object3, 0);
					placeElementOnObject(ui.object4, 1);
					break;
					
				case TutorialGoals.CONTROL_PROGRESS_WAIT_FOR_ENOUGH:
					placeElementOnObject(ui.object6);
					break;
					
				case TutorialGoals.PLACE_WALL_BUILD_MODE:
				case TutorialGoals.PLACE_BARRIER_BUILD_IT:
				case TutorialGoals.CONTROL_PROGRESS_BUILD_IT:
				case TutorialGoals.UNBUILDABLE_TILES_BUILD_MODE:
					placeElementOnObject(ui.buildButton);
					currentElements[0].visible = !gameScreen.isBuildMode();
					break;
					
				case TutorialGoals.PLACE_BARRIER_SELECT_IT:
					placeElementOnObject(ui.object2);
					break;
					
				case TutorialGoals.HURT_WALL_HIT_WALL:
					placeElementsOnWalls(step, gameScreen, ui, map);
					break;
					
				default:
					throw new Error("The tutorial step has no element placement referred to it. Put an empty case if there is none to it.");
			}
		}
		
		private function addElement(step:String, gameScreen:GameScreen):void
		{
			var element:MovieClip = new (getClassForTutorialStep(step))();
			gameScreen.addUIElement(element);
			currentElements.push(element);
		}
		
		private function placeElementOnObject(img:DisplayObject, elementIndex:Number = 0):void
		{
			currentElements[elementIndex].x = img.x;
			currentElements[elementIndex].y = img.y;
		}
		
		private function placeElementsOnWalls(step:String, gameScreen:GameScreen, ui:GameUI,
											  map:Map):void
		{
			var destroyable:Array = map.getDestroyableObjects();
			if (oldWallsCount != destroyable.length || walls == null || changedStep) // if a destroyable item has been added/removed
			{
				clearElements(gameScreen);
				walls = new Array();
				for each (var obj:LivingWorldObject in destroyable)
				{
					if (obj is WallMapObject) // it's a wall resource
					{
						addElement(step, gameScreen);
						walls.push(obj);
					}
				}
				addElement(step, gameScreen); // add circle around knife item
			}
			for (var wallIndex:Number = 0; wallIndex < walls.length; ++wallIndex)
			{
				var screenCoords:Point = map.camera.worldToScreenCoords(
													new Point(walls[wallIndex].x, walls[wallIndex].y));	
				currentElements[wallIndex].x = screenCoords.x;
				currentElements[wallIndex].y = screenCoords.y;
			}
			currentElements[walls.length].x = ui.weapon1.x;
			currentElements[walls.length].y = ui.weapon1.y;
			oldWallsCount = destroyable.length;
		}
		
		private function placeElementsOnConsecutiveShopIcons(startShopIndex:Number, iconsCount:Number,
															 step:String, gameScreen:GameScreen):void
		{
			if (currentElements.length != 0 && !gameScreen.shopScreen.visible || changedStep) 
				clearElements(gameScreen);
				
			else if (gameScreen.shopScreen.visible)
			{
				if (currentElements.length == 0)
				{
					for (var iconIndex:Number = 0; iconIndex < iconsCount; ++iconIndex)
					{
						addElement(step, gameScreen);
						placeElementOnShopButton(iconIndex, startShopIndex+iconIndex, gameScreen);
					}
				}
			}
		}
		
		private function placeElementOnShopButton(elementIndex:Number, shopIndex:Number, gameScreen:GameScreen):void
		{
			var objIcon:ShopItemButton = gameScreen.shopScreen.getObjectIcon(shopIndex);
			var objIconOnScreen:Rectangle = objIcon.getBounds(gameScreen);
			currentElements[elementIndex].x = objIconOnScreen.x + ShopItemButton.DIMENSION / 2;
			currentElements[elementIndex].y = objIconOnScreen.y + ShopItemButton.DIMENSION / 2;
		}
		
		private function placeElementOnShopBuyIf(condition:Boolean, gameScreen:GameScreen):void
		{
			currentElements[0].visible = gameScreen.shopScreen.visible &&
				gameScreen.shopScreen.buyButton != null &&
				condition;
			if (currentElements[0].visible)
			{
				var buyButtonOnScreen:Rectangle = gameScreen.shopScreen.buyButton.getBounds(gameScreen);
				currentElements[0].x = buyButtonOnScreen.x + buyButtonOnScreen.width / 2;
				currentElements[0].y = buyButtonOnScreen.y + buyButtonOnScreen.height / 2;
			}
		}
		
		private function placeElementFollowPlayer(player:Player, map:Map):void
		{
			var screenCoords:Point = map.camera.worldToScreenCoords(
												new Point(player.x, player.y));
			currentElements[0].x = screenCoords.x;
			currentElements[0].y = screenCoords.y;
		}
		
		private function placeElementsOnResources(type:String, step:String, map:Map, 
												  gameScreen:GameScreen):void
		{
			var resourceObjects:Array = map.getResourceObjects();
			if (oldResourcesCount != resourceObjects.length || resources == null || changedStep) // if a resource has been added/removed
			{
				clearElements(gameScreen);
				resources = new Array();
				for each (var resource:MapResource in resourceObjects)
				{
					if (resource.getResourceType() == type) // it's the right resource type
					{
						addElement(step, gameScreen);
						resources.push(resource);
					}
				}
			}
			for (var i:Number = 0; i < resources.length; ++i)
			{
				var screenCoords:Point = map.camera.worldToScreenCoords(
													new Point(resources[i].x, resources[i].y));	
				currentElements[i].x = screenCoords.x;
				currentElements[i].y = screenCoords.y;
			}
			oldResourcesCount = resourceObjects.length;
		}
		
		private function placeElementOnResourceAmountDisplay(display:ResourceOutput):void
		{
			currentElements[0].x = display.x + display.getWidth() / 2;
			currentElements[0].y = display.y + display.getHeight() / 2;
		}
	}
	
}
