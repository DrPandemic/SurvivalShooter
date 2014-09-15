package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import fl.motion.Color;
	import flash.events.Event;
	
	
	
	public class ShopMenuScreen extends MovieClip {
		
		private var itemArray:Array;
		
		private static const xPos:Number = 500;
		private static const yPos:Number = 50;
		
		private static const DISABLED_ALPHA:Number = 0.5;
		
		//icons positionning
		private static const firstX = 35;
		private static const firstY = 35;
		
		private static const xSpacesing = 60;
		private static const ySpacesing = 60;
		
		private static const MaxX = 280;
		
		//buying
		private var buyingItem:String;
		public var buyButton:BuyButton;
		private var costDisplay:ShopItemCost;
		private var itemDisplay:Item;
		
		private var _inventory:Inventory;
		private var _level:Number;
		
		public function ShopMenuScreen(inventory:Inventory, level:Number) {
			_inventory = inventory;
			_level = level;
			
			itemArray = new Array();
			
			x=xPos;
			y=yPos;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut,false,0,true);
			
			initIcons(null);
			alpha = 0.75;
		}
		public function onTick():void
		{
			if (buyButton && buyingItem && _inventory)
				buyButton.enabled = _inventory.canAfford(buyingItem);
		}
		private function onMouseMove(e:MouseEvent):void
		{
			InputEventCannon.mainInstance.setMouseOnShop(true);
		}
		private function onMouseOut(e:MouseEvent):void
		{
			InputEventCannon.mainInstance.setMouseOnShop(false);
		}
		private function initIcons(e:MouseEvent):void
		{
			itemArray.push(new ShopItemButton(ItemDB.GetItem(Inventory.HANDGUN_WEAPON)));
			itemArray.push(new ShopItemButton(ItemDB.GetItem(Inventory.MACHINE_GUN_WEAPON)));
			itemArray.push(new ShopItemButton(ItemDB.GetItem(Inventory.SHOTGUN_WEAPON)));
			itemArray.push(new ShopItemButton(ItemDB.GetItem(Inventory.SNIPER_WEAPON)));
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.FIRE_WAVE)));
			
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.AMMO_20),20));
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.AMMO_50),50));
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.AMMO_100),100));
			
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.AMMO2_20),20));
			itemArray.push(new ShopItemButton( ItemDB.GetItem(Inventory.AMMO2_50),50));
			
			checkToRemoveLockedItems(); // remove the ones that are too advanced for the current level
			
			checkToHideOwnedWeapons();

			placeArray();
		}
		
		private function checkToRemoveLockedItems():void
		{
			var unlocked:Array = new Array();
			for each (var button:ShopItemButton in itemArray)
			{
				if (_level >= ItemDB.GetLevelToUnlock(button._iconImage.kind))
					unlocked.push(button);
			}
			itemArray = unlocked;
		}
		
		private function checkToHideOwnedWeapons():void
		{
			for (var i:Number = 0; i < itemArray.length; ++i)
			{
				var weapon:String = itemArray[i]._iconImage.kind;
				if (_inventory.hasWeapon(weapon) && // already own weapon
					!_inventory.weaponShouldShowQuantity(weapon)) // and it's not one with a quantity
				{
					itemArray[i].enabled = false; // hide it
					itemArray[i].alpha = DISABLED_ALPHA;
				}
			}
		}
		private function placeArray():void
		{
			var baseX:Number = firstX;
			var baseY:Number = firstY;
			
			
			for each(var item:ShopItemButton in itemArray)
			{
				item.x = baseX;
				item.y = baseY;
				
				addChild(item);
				
				baseX+=xSpacesing;
				if(baseX>=MaxX)
				{
					baseX = firstX;
					baseY += ySpacesing;
				}
				//events
				item.addEventListener(ShopEvent.SELECT, onItemClick,false,0,true);
				item.addEventListener(ShopEvent.BUY, onBuyDouble,false,0,true);
			}
		}
		private function removeArray():void
		{
			if(itemArray.length>0)
			{
				for each(var item:ShopItemButton in itemArray)
				{
					//events
					item.removeEventListener(ShopEvent.SELECT, onItemClick);
					item.removeEventListener(ShopEvent.BUY, onBuyDouble);

					

					removeChild(item);
					item=null;
				
				}
				for(var i = itemArray.length;i>0;i--)
				{
					itemArray.pop();
				}
			}
		}
		private function onItemClick(e:ShopEvent):void
		{
			if (!e.target.enabled) return;
			removeSelectedItemData();
			
			buyingItem = e.theItem.kind;
			buyButton = new BuyButton();
			
			costDisplay = new ShopItemCost(e.theItem.cost.baseCost, e.theItem.cost.techCost);			
			
			itemDisplay = GeneralHelper.clone(e.theItem);
			
			costDisplay.x = 100;
			costDisplay.y = 215;
			buyButton.x = 250;
			buyButton.y = 255;
			itemDisplay.x = 50;
			itemDisplay.y = 250;
			
			addChild(costDisplay);
			addChild(buyButton);
			addChild(itemDisplay);
			
			buyButton.addEventListener(MouseEvent.CLICK, onBuy,false,0,true);
			
			// Check to update the tutorial
			if (buyingItem == Inventory.HANDGUN_WEAPON)
				Tutorial.onDone(TutorialGoals.BUY_GUN_CLICK_HANDGUN);
				
			else if (buyingItem == Inventory.AMMO_20 ||
				buyingItem == Inventory.AMMO_50 ||
				buyingItem == Inventory.AMMO_100)
				Tutorial.onDone(TutorialGoals.BUY_AMMO_CLICK_AMMO);
				
			else if (buyingItem == Inventory.MACHINE_GUN_WEAPON ||
					 buyingItem == Inventory.SHOTGUN_WEAPON)
				Tutorial.onDone(TutorialGoals.BUY_TIER2_WEAPON_SELECT_WEAPON);
		}
		
		private function removeSelectedItemData():void
		{
			if(buyButton!=null)
			{
				buyButton.removeEventListener(MouseEvent.CLICK, onBuy);

				removeChild(costDisplay);
				removeChild(buyButton);
				removeChild(itemDisplay);
				
				itemDisplay=null;
				buyButton=null;
				costDisplay=null;
			}
			stage.focus = stage;
		}

		private function onBuy(e:MouseEvent):void
		{
			
			var cost:Cost = CostDB.CostFor(buyingItem);
			
			// If we have enough resources to buy it
			if(cost.baseCost<=_inventory.getResourceQuantity(Inventory.BASE_RESOURCE)&&
			   cost.techCost<=_inventory.getResourceQuantity(Inventory.TECH_RESOURCE)&&
			   cost.progressCost<=_inventory.getResourceQuantity(Inventory.PROGRESS_RESOURCE))
			{
				// Spend the money and then check what we bought
				_inventory.spendResources(cost);
				
				// We bought a weapon
				if(buyingItem == Inventory.HANDGUN_WEAPON || buyingItem == Inventory.MACHINE_GUN_WEAPON ||
			   		buyingItem == Inventory.SHOTGUN_WEAPON || buyingItem == Inventory.SNIPER_WEAPON 
					|| buyingItem == Inventory.FIRE_WAVE)
				{
					// Get the weapon
					_inventory.acquireWeapon(buyingItem);
					
					// If the weapon is not one with a quantity
					if (!_inventory.weaponShouldShowQuantity(buyingItem))
					{
						// We can't buy twice the same weapon, so we hide it from the shop and unselect it.
						checkToHideOwnedWeapons();
						removeSelectedItemData();
					}
					
					// Check to update the tutorial about buying weapons
					if (buyingItem == Inventory.HANDGUN_WEAPON)
						Tutorial.onDone(TutorialGoals.BUY_GUN_CLICK_BUY);
					else if (buyingItem == Inventory.MACHINE_GUN_WEAPON ||
							 buyingItem == Inventory.SHOTGUN_WEAPON)
						Tutorial.onDone(TutorialGoals.BUY_TIER2_WEAPON_BUY_IT);
					else if (buyingItem == Inventory.SNIPER_WEAPON)
						Tutorial.onDone(TutorialGoals.BUY_SNIPER_BUY_IT);
					else if (buyingItem == Inventory.FIRE_WAVE)
						Tutorial.onDone(TutorialGoals.GRENADE_BUY);
				}
				
				// We bought regular ammo
				else if(buyingItem == Inventory.AMMO_20 || buyingItem == Inventory.AMMO_50 ||
						buyingItem == Inventory.AMMO_100)
				{
					// Get the regular ammo
					_inventory.addAmmo(buyingItem);
					
					// Update the tutorial about buying normal ammo
					Tutorial.onDone(TutorialGoals.BUY_AMMO_BUY_AMMO);
				}
				
				// We bought advanced ammo
				else if(buyingItem == Inventory.AMMO2_20 ||
						buyingItem == Inventory.AMMO2_50 || buyingItem == Inventory.AMMO2_100)
				{
					// Get the advanced ammo
					_inventory.addAmmo(buyingItem);
					
					Tutorial.onDone(TutorialGoals.BUY_SNIPER_BUY_AMMO);
				}
				
				// We bought an item
				else if(buyingItem == Inventory.BRICK_WALL || buyingItem == Inventory.ROCK_WALL || 
						buyingItem == Inventory.AUTO_TURRET || buyingItem == Inventory.SPIKE_TRAP ||
						buyingItem == Inventory.PROD_BOOSTER)
				{
					// Receive the item
					_inventory.addObject(buyingItem,1);
				}
				
				else if (buyingItem == Inventory.PROGRESS_RESOURCE)
				{
					_inventory.addObject(buyingItem, 1);
				}
				else if(1==0) //lol.
				{
				
				}
				else
				{
					throw new Error("Trying to buy a non-existent object");
				}
			}			
		}
	
		private function onBuyDouble(e:ShopEvent):void
		{
			onItemClick(e);
			onBuy(null);
		}
		
		public function getObjectIcon(index:Number):ShopItemButton
		{
			return itemArray[index];
		}
		
		public function getSelectedItem():String
		{
			return buyingItem;
		}
	}
	
}
