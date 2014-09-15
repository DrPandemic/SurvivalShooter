package  {
	import flash.utils.Dictionary;
	import flashx.textLayout.debug.assert;
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	
	public class Inventory extends EventDispatcher {
		//resources
		public static const PROGRESS_RESOURCE:String = "Progress";
		public static const TECH_RESOURCE:String = "Tech";
		public static const BASE_RESOURCE:String = "Base";
		public static const KILL_RESOURCE:String = "Kill";
		
		//weapons
		public static const KNIFE_WEAPON:String = "Knife";
		public static const HANDGUN_WEAPON:String = "Handgun";
		public static const MACHINE_GUN_WEAPON:String = "MachineGun";
		public static const SHOTGUN_WEAPON:String = "Shotgun";
		public static const SNIPER_WEAPON:String = "Sniper";
		public static const FIRE_WAVE:String = "FireWave";
		
		//items
		public static const ROCK_WALL:String = "RockWall";
		public static const BRICK_WALL:String = "BrickWall";
		public static const AUTO_TURRET:String = "AutoTurret";
		public static const SPIKE_TRAP:String = "SpikeTrap";
		public static const PROD_BOOSTER:String = "ProdBooster";
		
		
		//ammos
		public static const AMMO:String = "Ammo";
		public static const AMMO2:String = "Ammo2";
		//ammo packs
		public static const AMMO_20:String = "Ammo_20";
		public static const AMMO_50:String = "Ammo_50";
		public static const AMMO_100:String = "Ammo_100";
		public static const AMMO2_20:String = "Ammo2_20";
		public static const AMMO2_50:String = "Ammo2_50";
		public static const AMMO2_100:String = "Ammo2_100";

		
		// keep a dictionary for a flexible design (easy to add/remove elements)
		private var _resources:Dictionary;
		private var _weapons:Dictionary;
		private var _items:Dictionary;
		private var _ammo:Dictionary;
		private var _globalDictionary:Dictionary;
		
		// Item ordering dictionaries.
		// These are required since a dictionary does not keep the initial ordering sequence,
		// it sorts them alphabetically to find them faster, so we need to keep the order that we want
		// (and it lets us swap item orders easily).
		
		// the array that keeps a list of the indices for each item.
		private var _itemsOrdering:Array;
		// the array that keeps a list of the indices for each weapon.
		private var _weaponsOrdering:Array;
		
		private var _selectedItemIndex:Number;
		private var _selectedWeaponIndex:Number;

		public function Inventory() {
			_selectedItemIndex = 0;
			_selectedWeaponIndex = 0;
			
			_resources = new Dictionary();			
			_weapons = new Dictionary();
			_items = new Dictionary();
			_ammo = new Dictionary();
			_globalDictionary = new Dictionary();
			
			_itemsOrdering = new Array();
			_weaponsOrdering = new Array();
			
			populateDictionaries();

		}
		
		private function populateDictionaries():void
		{
			_resources[PROGRESS_RESOURCE] = 0;
			_resources[TECH_RESOURCE] = 0;
			_resources[BASE_RESOURCE] = 0;
			_resources[KILL_RESOURCE] = 0;
			
			_weaponsOrdering.push(KNIFE_WEAPON);
			_weaponsOrdering.push(HANDGUN_WEAPON);
			_weaponsOrdering.push(MACHINE_GUN_WEAPON);
			_weaponsOrdering.push(SHOTGUN_WEAPON);
			_weaponsOrdering.push(SNIPER_WEAPON);
			_weaponsOrdering.push(FIRE_WAVE);
			initDict(_weapons, _weaponsOrdering);
			
			_itemsOrdering.push(ROCK_WALL);
			_itemsOrdering.push(BRICK_WALL);
			_itemsOrdering.push(AUTO_TURRET);
			_itemsOrdering.push(SPIKE_TRAP);
			_itemsOrdering.push(PROD_BOOSTER);
			_itemsOrdering.push(PROGRESS_RESOURCE);
			initDict(_items, _itemsOrdering);
			
			_ammo[AMMO] = 0;
			_ammo[AMMO2] = 0;
			_ammo[FIRE_WAVE] = 0; // we don't initialize the global dictionary with this so that it doesn't mess up the firewave weapon.
			
			//global dictionary
			_globalDictionary[KNIFE_WEAPON]=_weapons;
			_globalDictionary[HANDGUN_WEAPON]=_weapons;
			_globalDictionary[SHOTGUN_WEAPON]=_weapons;
			_globalDictionary[MACHINE_GUN_WEAPON]=_weapons;
			_globalDictionary[SNIPER_WEAPON]=_weapons;
			_globalDictionary[FIRE_WAVE]=_weapons;
			
			_globalDictionary[ROCK_WALL]=_items;
			_globalDictionary[BRICK_WALL]=_items;
			_globalDictionary[AUTO_TURRET]=_items;
			_globalDictionary[SPIKE_TRAP]=_items;
			_globalDictionary[PROD_BOOSTER]=_items;
			_globalDictionary[PROGRESS_RESOURCE]=_items;
						
			_globalDictionary[AMMO]=_ammo;
			_globalDictionary[AMMO2]=_ammo;
			
			updateItemQuantities();
		}
		private function initDict(dict:Dictionary, ordering:Array):void
		{
			for each(var itemName:String in ordering)
			{
				dict[itemName] = 0;
			}
		}
		public function collectResource(resourceName:String, quantity:Number):void
		{
			// error check
			if (quantity < 0) throw new Error("Invalid resource quantity.");
			
			modifyRessource(resourceName,quantity);
			
			// Check to update the tutorial
			if (canAfford(Inventory.HANDGUN_WEAPON))
				Tutorial.onDone(TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_FOR_ENOUGH_RESOURCES_FOR_GUN);
			if (canAfford(Inventory.PROGRESS_RESOURCE))
				Tutorial.onDone(TutorialGoals.CONTROL_PROGRESS_WAIT_FOR_ENOUGH);

		}
		public function collectResources(cost:Cost, quantity:Number = 1):void
		{
			for (var i:Number = 0; i < quantity; ++i)
			{
				collectResource(Inventory.BASE_RESOURCE, cost.baseCost);
				collectResource(Inventory.TECH_RESOURCE, cost.techCost);
				collectResource(Inventory.PROGRESS_RESOURCE, cost.progressCost);
			}
		}
		public function spendResources(cost:Cost):void
		{
			spendResource(Inventory.BASE_RESOURCE,cost.baseCost);
			spendResource(Inventory.TECH_RESOURCE,cost.techCost);
			spendResource(Inventory.PROGRESS_RESOURCE,cost.progressCost);
		}
		public function spendResource(resourceName:String, quantity:Number):void
		{
			// error check
			if (quantity < 0) throw new Error("Invalid resource quantity.");
			
			modifyRessource(resourceName,-quantity);
		}
		private function modifyRessource(resourceName:String, quantity:Number):void
		{
			if (_resources[resourceName] == undefined) throw new Error("Invalid resource name.");
			
			var oldRounded:int = (int)(_resources[resourceName]);
			_resources[resourceName] += quantity;
			var newRounded:int = (int)(_resources[resourceName]);
			
			//dispatch event when the resource changes
			if (oldRounded != newRounded)
			{
				// check if we're aloud to buy new items
				updateItemQuantities();
				
				// fire the resource change event
				InputEventCannon.mainInstance.dispatchEvent(new CharacterEvent(resourceName,_resources[resourceName]));
			}
		}
		
		// Updates the quantities of the items based on which ones we can buy and which
		// ones we can't.
		private function updateItemQuantities():void
		{
			// the grenade amount is the same as the weapons amount of it.
			// So we simply update it anytime we modify an object (add/remove weapon, item, etc.)
			_ammo[FIRE_WAVE] = _weapons[FIRE_WAVE];
			
			for each (var itemName:String in _itemsOrdering)
			{
				_items[itemName] = canAfford(itemName) ? 1 : 0;
			}
			onItemQuantitiesChanged();
		}
		
		public function canAfford(obj:String):Boolean
		{
			var cost:Cost = CostDB.CostFor(obj);
			
			return getResourceQuantity(Inventory.BASE_RESOURCE) >= cost.baseCost &&
				getResourceQuantity(Inventory.TECH_RESOURCE) >= cost.techCost &&
				getResourceQuantity(Inventory.PROGRESS_RESOURCE) >= cost.progressCost;
		}

		public function getResourceQuantity(resourceName:String):Number
		{
			if (_resources[resourceName] == undefined) throw new Error("Invalid resource name.");
				
			return _resources[resourceName];
		}
		
		public function addObject(str:String, amount:Number):void
		{
			if(amount>0)
				_globalDictionary[str][str]+=amount;
			else
				throw new Error("Invalid amount added to an object in the inventory. Must be positive.");
				
			updateItemQuantities();
		}
		public function addAmmo(str:String):void
		{
			switch(str)
			{
				case Inventory.AMMO_20:
				collectAmmo(Inventory.AMMO,20);
				break;
				case Inventory.AMMO_50:
				collectAmmo(Inventory.AMMO,50);
				break;
				case Inventory.AMMO_100:
				collectAmmo(Inventory.AMMO,100);
				break;
				case Inventory.AMMO2_20:
				collectAmmo(Inventory.AMMO2,20);
				break;
				case Inventory.AMMO2_50:
				collectAmmo(Inventory.AMMO2,50);
				break;
				case Inventory.AMMO2_100:
				collectAmmo(Inventory.AMMO2,100);
				break;
				default:
				throw new Error("Ammo quantity/type math-up not implemented.");
			}
		}

		public function removeObject(str:String, amount:Number):void
		{
			if(amount>0 && (_globalDictionary[str][str]-amount)>=0)
				_globalDictionary[str][str]-=amount;
				
			updateItemQuantities();
		}
		private function onItemQuantitiesChanged():void
		{
			var event:InventoryEvent = new InventoryEvent(InventoryEvent.ITEM_QUANTITIES_CHANGED);
			var itemQuantities:Array = new Array();
			
			for each (var itemName:String in _itemsOrdering)
			{
				itemQuantities.push(_items[itemName]);
			}
			event.items = itemQuantities;
			
			dispatchEvent(event);
		}
		public function isEmpty():Boolean
		{
			for each (var qty:Number in _items)
			{
				if (qty != 0) return false;
			}
			return true;
		}
		public function getSelectedWorldObject():WorldObject
		{
			var itemName:String = _itemsOrdering[_selectedItemIndex]; // find the name of the selected object
			
			if (_items[itemName] <= 0) throw new Error("Trying to build an item that we don't have!");
			
			var object:WorldObject = ItemDB.GetItemIngameWorldObject(itemName); // get its world object
			
			if (object == null) throw new Error("Selected object is impossible to create.");
			return object; // and send it to be placed
		}
		public function getSelectedItemName():String
		{
			return _itemsOrdering[_selectedItemIndex];
		}
		public function useSelectedWorldObject():void
		{
			var itemName:String = _itemsOrdering[_selectedItemIndex]; // find the name of the selected object
			
			if (_items[itemName] <= 0) throw new Error("Trying to build an item that we don't have!");
			
			spendResources(CostDB.CostFor(itemName));
			removeObject(itemName, 1); // remove one from our inventory
		}
		public function onSelectedItemChanged(e:InventoryEvent):void
		{
			_selectedItemIndex = e.selectedItemIndex;
			
			// Update the tutorial about selecting certain items
			if (getSelectedItemName() == BRICK_WALL)
				Tutorial.onDone(TutorialGoals.PLACE_BARRIER_SELECT_IT);
		}
		public function acquireWeapon(weaponName:String):void
		{
			addObject(weaponName, 1);
			
			onWeaponQuantitiesChanged();
		}
		public function loseWeapon(weaponName:String):void
		{
			removeObject(weaponName, 1);
			
			onWeaponQuantitiesChanged();
		}
		private function onWeaponQuantitiesChanged():void
		{
			var event:InventoryEvent = new InventoryEvent(InventoryEvent.WEAPON_POSSESSIONS_CHANGED);
			var weaponPossessions:Array = new Array();
			
			for each (var weaponName:String in _weaponsOrdering)
			{
				weaponPossessions.push(_weapons[weaponName]);
			}
			event.weapons = weaponPossessions;
			
			dispatchEvent(event);
		}
		
		public function onSelectedWeaponChanged(e:InventoryEvent):void
		{
			_selectedWeaponIndex = e.selectedWeaponIndex;
			
			var inventoryEvent:InventoryEvent = new InventoryEvent(e.type);
			inventoryEvent.selectedWeaponIndex = e.selectedWeaponIndex;
			dispatchEvent(inventoryEvent);
			
			// Update the tutorial about choosing a gun
			Tutorial.onDone(TutorialGoals.SELECT_GUN_CHANGE_IT);
		}
		public function getSelectedWeapon():WorldWeapon
		{
			var weapName:String = _weaponsOrdering[_selectedWeaponIndex];
			
			if (_weapons[weapName] == 0) throw new Error("Trying to select a weapon that isn't owned by the player.");
			
			var weapon = ItemDB.GetItemIngameWorldObject(weapName);
			return weapon;
		}
		
		/// Picks the melee weapon of the player.
		/// Example use: when we shoot with a weapon without ammo,
		/// switch to the melee weapon.
		public function pickMeleeWeapon():void
		{
			InputEventCannon.mainInstance.dispatchEvent(new InputEvents(InputEvents.WEAPON_1));
		}
		
		public function collectAmmo(ammoType:String, quantity:Number):void
		{
			if (quantity <= 0) throw new Error("Invalid quantity for ammo.");
			if (_ammo[ammoType] == undefined) throw new Error("Ammo type doesn't exist when collecting ammo.");
			
			_ammo[ammoType] += quantity;
			
			onAmmoQuantityChanged(ammoType);
		}
		
		public function getAmmoQuantity(ammoType:String):Number
		{
			if (_ammo[ammoType] == undefined) throw new Error("Ammo type doesn't exist while getting the ammo quantity.");
			return _ammo[ammoType];
		}
		
		private function onAmmoQuantityChanged(ammoType:String):void
		{
			var e:CharacterEvent = new CharacterEvent(ammoType, _ammo[ammoType]);
			InputEventCannon.mainInstance.dispatchEvent(e);
		}
		
		public function hasEnoughAmmo(ammoType:String, quantity:Number):Boolean
		{
			if (_ammo[ammoType] == undefined) throw new Error("Ammo type isn't implemented when checking if player has enough ammo.");
			if (quantity <= 0) throw new Error("Ammo quantity isn't positive when checking if player has enough ammo.");
			return _ammo[ammoType] >= quantity;
		}
		
		public function removeAmmo(ammoType:String, quantity:Number):void
		{
			if (quantity > _ammo[ammoType]) throw new Error("Quantity too big for ammo count.");
			if (_ammo[ammoType] == undefined) throw new Error("Invalid ammo type while removing ammo.");
			
			_ammo[ammoType] -= quantity;
			// update the firewave amount compared to our bullet quantity
			if (ammoType == FIRE_WAVE) loseWeapon(FIRE_WAVE);
			
			onAmmoQuantityChanged(ammoType);
		}
		
		public function getItemIcon(index:Number):MovieClip
		{
			return ItemDB.GetItem(_itemsOrdering[index]);
		}
		public function getWeaponIcon(index:Number):MovieClip
		{
			return ItemDB.GetItem(_weaponsOrdering[index]);
		}
		public function hasWeapon(weaponName:String):Boolean
		{
			return _weapons[weaponName] != undefined && _weapons[weaponName] > 0;
		}
		
		// If the specified weapon should show a quantity (useable weapons)
		public function weaponShouldShowQuantity(weapon:String):Boolean
		{
			if (_weaponsOrdering[weapon])
				throw new Error("Invalid weapon name.");
				
			return weapon == FIRE_WAVE; // only show quantity for the fire wave
		}
		
		public function getWeaponName(weaponIndex:Number):String
		{
			if (weaponIndex < 0 || weaponIndex >= _weaponsOrdering.length)
				throw new Error("Invalid weapon index.");
			return _weaponsOrdering[weaponIndex];
		}
		
		
		public function getItemName(itemIndex:Number):String
		{
			if (itemIndex < 0 || itemIndex >= _itemsOrdering.length)
				throw new Error("Invalid item index.");
			return _itemsOrdering[itemIndex];
		}
	}
	
}
