package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	
	public class GameUI extends MovieClip {
		private const TUTORIAL_TEXT_ALPHA:Number = 1;
		public static const MAP_START_Y:Number = 50;
		private const HIDDEN_ICON_ALPHA:Number = 0.3;
		private const SHOWN_ICON_ALPHA:Number = 1;
		
		private var weaponSelection:Number;
		private var itemSelection:Number;
		
		private var itemIconArray:Array;
		private var weaponIconArray:Array;
		
		private var itemQuantities:Array;
		private var isInventoryEmpty:Boolean;
		
		private var weaponPossessions:Array;
		
		private var progressResourceForWin:Number;
		private var killResourceForWin:Number;
		
		private var inventory:Inventory;
		private var level:Number;
		
		private var upperTooltip:UpperUITooltip;
		private var lowerTooltip:LowerUITooltip;
		
		public function GameUI(inventory:Inventory, level:Number,
							   progressResourceForWin:Number,
							   killResourceForWin:Number) {
			this.inventory = inventory;
			this.level = level;
			
			this.progressResourceForWin = progressResourceForWin;
			this.killResourceForWin = killResourceForWin;
			
			itemIconArray=new Array();
			weaponIconArray=new Array();
			
			//put the icons in the arrays
			itemIconArray.push(object1);
			itemIconArray.push(object2);
			itemIconArray.push(object3);
			itemIconArray.push(object4);
			itemIconArray.push(object5);
			itemIconArray.push(object6);
			
			itemIconArray = onlyKeepUnlockedItems(itemIconArray, false);
			
			for (var i:Number = 0; i < itemIconArray.length; ++i)
			{
				itemIconArray[i].setIcon(inventory.getItemIcon(i));
				itemIconArray[i].index = i;
				itemIconArray[i].addEventListener(MouseEvent.CLICK, onItemClick,false,0,true);
				itemIconArray[i].allowTooltip();
				itemIconArray[i].setTooltipInfo(inventory.getItemName(i));
			}
			
			
			weaponIconArray.push(weapon1);
			weaponIconArray.push(weapon2);
			weaponIconArray.push(weapon3);
			weaponIconArray.push(weapon4);
			weaponIconArray.push(weapon5);
			weaponIconArray.push(weapon6);
			
			weaponIconArray = onlyKeepUnlockedItems(weaponIconArray, true);
			
			for (i = 0; i < weaponIconArray.length; ++i)
			{
				weaponIconArray[i].setIcon(inventory.getWeaponIcon(i));
				weaponIconArray[i].index = i;
				weaponIconArray[i].addEventListener(MouseEvent.CLICK, onWeaponClick,false,0,true);
				weaponIconArray[i].allowTooltip();
				weaponIconArray[i].setTooltipInfo(inventory.getWeaponName(i));
				weaponIconArray[i].shortcutText.text = ((i+1).toString());
			}


			
			weaponSelection=0;
			itemSelection=0;
			
			//changing weapon/item
			InputEventCannon.mainInstance.addEventListener(InputEvents.ITEM_CHOICE_DOWN, ItemDown,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.ITEM_CHOICE_UP, ItemUp,false,0,true);
			//weapon
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_1, WeaponChange,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_2, WeaponChange,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_3, WeaponChange,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_4, WeaponChange,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_5, WeaponChange,false,0,true);
			InputEventCannon.mainInstance.addEventListener(InputEvents.WEAPON_6, WeaponChange,false,0,true);


			//resource update
			InputEventCannon.mainInstance.addEventListener(Inventory.BASE_RESOURCE,BaseUpdate,false,0,true);
			InputEventCannon.mainInstance.addEventListener(Inventory.PROGRESS_RESOURCE,ProgressUpdate,false,0,true)
			InputEventCannon.mainInstance.addEventListener(Inventory.TECH_RESOURCE,TechUpdate,false,0,true);
			InputEventCannon.mainInstance.addEventListener(Inventory.KILL_RESOURCE,KillsUpdate,false,0,true);
			
			
			//Ammo
			InputEventCannon.mainInstance.addEventListener(CharacterEvent.AMMO,AmmoUpdate,false,0,true);
			InputEventCannon.mainInstance.addEventListener(CharacterEvent.AMMO2,Ammo2Update,false,0,true);
			
			//Life
			lifePool.gotoAndStop(10);
			InputEventCannon.mainInstance.addEventListener(CharacterEvent.LIFE,LifeUpdate,false,0,true);
			
			// Inventory events
			itemQuantities = new Array();
			isInventoryEmpty = true;
			addEventListener(InventoryEvent.SELECTED_ITEM_CHANGED, inventory.onSelectedItemChanged,false,0,true);
			inventory.addEventListener(InventoryEvent.ITEM_QUANTITIES_CHANGED, OnItemQuantitiesChanged,false,0,true);
			
			// Weapon events
			addEventListener(InventoryEvent.SELECTED_WEAPON_CHANGED, inventory.onSelectedWeaponChanged,false,0,true);
			inventory.addEventListener(InventoryEvent.WEAPON_POSSESSIONS_CHANGED, OnWeaponPossessionsChanged,false,0,true);
			
			BaseUpdate(new CharacterEvent("", inventory.getResourceQuantity(Inventory.BASE_RESOURCE)));
			TechUpdate(new CharacterEvent("", inventory.getResourceQuantity(Inventory.TECH_RESOURCE)));
			ProgressUpdate(new CharacterEvent("", inventory.getResourceQuantity(Inventory.PROGRESS_RESOURCE)));
			KillsUpdate(new CharacterEvent("", inventory.getResourceQuantity(Inventory.KILL_RESOURCE)));
			
			tutorialText.alpha = TUTORIAL_TEXT_ALPHA;
			
			// Check to hide stuff that is not unlocked yet
			hideUIIfTooLowLevel(baseIcon, Inventory.BASE_RESOURCE);
			hideUIIfTooLowLevel(resource1, Inventory.BASE_RESOURCE);
			
			hideUIIfTooLowLevel(techIcon, Inventory.TECH_RESOURCE);
			hideUIIfTooLowLevel(resource2, Inventory.TECH_RESOURCE);
			
			hideUIIfTooLowLevel(progressIcon, Inventory.PROGRESS_RESOURCE);
			hideUIIfTooLowLevel(resource3, Inventory.PROGRESS_RESOURCE);
			
			hideUIIfTooLowLevel(killsIcon, Inventory.KILL_RESOURCE);
			hideUIIfTooLowLevel(resource4, Inventory.KILL_RESOURCE);
			
			hideUIIfTooLowLevel(textAmmo2, Inventory.AMMO2);
			hideUIIfTooLowLevel(ammo2Icon, Inventory.AMMO2);
			
			upperTooltip = new UpperUITooltip();
			upperTooltip.visible = false;
			addChild(upperTooltip);
			
			baseIcon.addEventListener(MouseEvent.MOUSE_MOVE, showBaseTooltip, false,0,true);
			baseIcon.addEventListener(MouseEvent.MOUSE_OUT, hideUpperTooltip, false,0,true);
			
			techIcon.addEventListener(MouseEvent.MOUSE_MOVE, showTechTooltip, false,0,true);
			techIcon.addEventListener(MouseEvent.MOUSE_OUT, hideUpperTooltip, false,0,true);
			
			progressIcon.addEventListener(MouseEvent.MOUSE_MOVE, showProgressTooltip, false,0,true);
			progressIcon.addEventListener(MouseEvent.MOUSE_OUT, hideUpperTooltip, false,0,true);
			
			killsIcon.addEventListener(MouseEvent.MOUSE_MOVE, showKillsTooltip, false,0,true);
			killsIcon.addEventListener(MouseEvent.MOUSE_OUT, hideUpperTooltip, false,0,true);
			
			
			lowerTooltip = new LowerUITooltip();
			lowerTooltip.visible = false;
			addChild(lowerTooltip);
			
			ammoIcon.addEventListener(MouseEvent.MOUSE_MOVE, showAmmoTooltip, false,0,true);
			ammoIcon.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			ammo2Icon.addEventListener(MouseEvent.MOUSE_MOVE, showAmmo2Tooltip, false,0,true);
			ammo2Icon.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			lifePool.addEventListener(MouseEvent.MOUSE_MOVE, showLifeTooltip, false,0,true);
			lifePool.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			shopButton.addEventListener(MouseEvent.MOUSE_MOVE, showShopTooltip, false,0,true);
			shopButton.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			menuButton.addEventListener(MouseEvent.MOUSE_MOVE, showMenuTooltip, false,0,true);
			menuButton.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			buildButton.addEventListener(MouseEvent.MOUSE_MOVE, showBuildTooltip, false,0,true);
			buildButton.addEventListener(MouseEvent.MOUSE_OUT, hideLowerTooltip, false,0,true);
			
			resource1.setColor(ResourceOutput.BASE_COLOR);
			resource2.setColor(ResourceOutput.TECH_COLOR);
			resource3.setColor(ResourceOutput.PROGRESS_COLOR);
			resource4.setColor(ResourceOutput.KILL_COLOR);
		}
		
		private function showBuildTooltip(e:MouseEvent):void
		{
			showLowerTooltip(buildButton, "Build('Q') - build the selected item.");
		}
		private function showShopTooltip(e:MouseEvent):void
		{
			showLowerTooltip(shopButton, "Shop('E') - weapons and ammo for sale.");
		}
		private function showMenuTooltip(e:MouseEvent):void
		{
			showLowerTooltip(menuButton, "Menu('Escape') - general options about the game.");
		}
		private function showAmmoTooltip(e:MouseEvent):void
		{
			showLowerTooltip(ammoIcon, "Normal ammo - used by most of the guns.");
		}
		private function showAmmo2Tooltip(e:MouseEvent):void
		{
			showLowerTooltip(ammo2Icon, "High ammo - used by the sniper. Pierces through enemies.");
		}
		private function showLifeTooltip(e:MouseEvent):void
		{
			showLowerTooltip(lifePool, "Life - your current amount of health.");
		}
		private function showKillsTooltip(e:MouseEvent):void
		{
			showUpperTooltip(killsIcon, "Kill count - used to advance levels.");
		}
		private function showProgressTooltip(e:MouseEvent):void
		{
			showUpperTooltip(progressIcon, "Progress resource - used to advance levels.");
		}
		private function showTechTooltip(e:MouseEvent):void
		{
			showUpperTooltip(techIcon, "Tech resource - used to build advanced items.");
		}
		private function showBaseTooltip(e:MouseEvent):void
		{
			showUpperTooltip(baseIcon, "Rock resource - used to build everything.");
		}
		
		private function showUpperTooltip(item:DisplayObject, info:String):void
		{
			const MOUSE_OFFSET:Number = 5;
			upperTooltip.setTooltip(info);
			upperTooltip.x = mouseX + MOUSE_OFFSET;
			upperTooltip.y = mouseY + MOUSE_OFFSET;
			upperTooltip.visible = true;
		}
		private function hideUpperTooltip(e:MouseEvent):void
		{
			upperTooltip.visible = false;
		}
		private function showLowerTooltip(item:DisplayObject, info:String):void
		{
			const MOUSE_OFFSET:Number = 5;
			lowerTooltip.setTooltip(info);
			lowerTooltip.x = mouseX - MOUSE_OFFSET;
			lowerTooltip.y = mouseY - MOUSE_OFFSET;
			
			if (lowerTooltip.x - lowerTooltip.width < 0) // too much on the left and going out of screen?
				lowerTooltip.x = mouseX + lowerTooltip.width + MOUSE_OFFSET; // place it on the right of the mouse instead
			lowerTooltip.visible = true;
		}
		
		private function hideLowerTooltip(e:MouseEvent):void
		{
			lowerTooltip.visible = false;
		}
		
		private function hideUIIfTooLowLevel(element:DisplayObject, itemName:String):void
		{
			if (level < ItemDB.GetLevelToUnlockUI(itemName))
				element.visible = false;
		}
		
		private function onlyKeepUnlockedItems(icons:Array, areWeapons:Boolean):Array
		{
			var unlocked:Array = new Array();
			
			for (var i:Number = 0; i < icons.length; ++i)
			{
				icons[i].visible = (level >= ItemDB.GetLevelToUnlock(areWeapons ? inventory.getWeaponName(i) : 
													 inventory.getItemName(i)));
				unlocked.push(icons[i]);
			}
			
			return unlocked;
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			if (itemQuantities[e.currentTarget.index] > 0 && // if we can select it
				itemSelection != e.currentTarget.index) // and we're not already targetting it
			{
				itemSelection = e.currentTarget.index;
				OnSelectedItemChanged();
			}
		}
		
		private function onWeaponClick(e:MouseEvent):void
		{
			if (weaponPossessions[e.currentTarget.index] != 0 && // if we own the weapon
				weaponSelection != e.currentTarget.index) // and we're not already holding it
			{
				weaponSelection = e.currentTarget.index;
				OnSelectedWeaponChanged();
			}
		}
		
		private function LifeUpdate(e:CharacterEvent):void
		{
			lifePool.gotoAndStop(Math.floor(e.quantity/10));
		}
		
		private function AmmoUpdate(e:CharacterEvent):void
		{
			textAmmo.text = formatAmmoAmount(e.quantity);
		}
		private function Ammo2Update(e:CharacterEvent):void
		{
			textAmmo2.text = formatAmmoAmount(e.quantity);
		}
		private function formatAmmoAmount(amount:Number):String
		{
			if (amount < 0) throw new Error("Invalid ammo amount. Negative ammo is impossible.");
			else if (amount < 1000000) return amount.toString();
			else return "999999+";// cap at 999999
		}
		
		private function BaseUpdate(e:CharacterEvent):void
		{
			resource1.setAmount(Math.floor(e.quantity).toString());
		}
		private function TechUpdate(e:CharacterEvent):void
		{
			resource2.setAmount(Math.floor(e.quantity).toString());			
		}
		private function ProgressUpdate(e:CharacterEvent):void
		{
			resource3.setAmount(getGoalText(Math.floor(e.quantity), progressResourceForWin));	
			if (e.quantity >= progressResourceForWin)
				resource3.setColor(ResourceOutput.PROGRESS_COMPLETE_COLOR);
		}
		private function KillsUpdate(e:CharacterEvent):void
		{
			resource4.setAmount(getGoalText(Math.floor(e.quantity), killResourceForWin));
			if (e.quantity >= killResourceForWin)
				resource4.setColor(ResourceOutput.KILL_COMPLETE_COLOR);
		}
		private function getGoalText(quantity:Number, goal:Number):String
		{
			return quantity.toString() + (goal != 0 && quantity < goal ? " / " + goal.toString() : "");
		}
		
		private function ItemDown(e:InputEvents):void
		{
			if (!isInventoryEmpty) // can't switch items if the inventory is empty!
			{
				do // while we don't find an item that we have
				{
					// go on the previous one
					itemSelection--;
					if(itemSelection<0)
						itemSelection=itemQuantities.length-1;
				} while (itemQuantities[itemSelection] <= 0 || !itemIconArray[itemSelection].visible);
					
				OnSelectedItemChanged();
			}
		}
		private function ItemUp(e:InputEvents):void
		{
			if (!isInventoryEmpty) // can't switch items if the inventory is empty!
			{
				do // while we don't find an item that we have
				{
					// go on the next one
					itemSelection++;
					if(itemSelection>=itemQuantities.length)
						itemSelection=0;
				} while (itemQuantities[itemSelection] <= 0 || !itemIconArray[itemSelection].visible);
					
				OnSelectedItemChanged();
			}
		}
		private function OnSelectedItemChanged():void
		{
			var event:InventoryEvent = new InventoryEvent(InventoryEvent.SELECTED_ITEM_CHANGED);
			event.selectedItemIndex = itemSelection;
			dispatchEvent(event);
			
			ItemSelectionUnder();
		}
		private function OnItemQuantitiesChanged(e:InventoryEvent):void
		{
			itemQuantities = e.items;
			
			// update the item texts to show the quantities owned
			for (var i:Number = 0; i < itemQuantities.length; ++i)
			{
				var qty:Number = itemQuantities[i];
				if (i < itemIconArray.length)
				{
					if (qty > 0) // we own the item
					{
						itemIconArray[i].alpha = SHOWN_ICON_ALPHA;
					}
					else // item not owned
					{
						itemIconArray[i].alpha = HIDDEN_ICON_ALPHA;
					}
					itemIconArray[i].quantityText.text = ""; // hide the quantity text
				}
			}
			
			if (itemQuantities.every(IsEqualToZero)) // empty inventory
			{
				isInventoryEmpty = true;
			}
			else // items still in there
			{
				isInventoryEmpty = false;
				
				if (itemQuantities[itemSelection] <= 0) // current item is equal to zero: find next item that we have
					ItemUp(null);
			}
			
			backItem.visible = !isInventoryEmpty; // only show selection box when the inventory has items
		}
		private function OnWeaponPossessionsChanged(e:InventoryEvent):void
		{
			weaponPossessions = e.weapons;
			
			// Show or hide the weapon icon, based on if we own it or not.
			for (var i:Number = 0; i < weaponPossessions.length; ++i)
			{
				if (i < weaponIconArray.length)
				{
					weaponIconArray[i].alpha = weaponPossessions[i] != 0 ? SHOWN_ICON_ALPHA : HIDDEN_ICON_ALPHA;
					if (inventory.weaponShouldShowQuantity(inventory.getWeaponName(i))) 
						weaponIconArray[i].quantityText.text = weaponPossessions[i].toString();
				}
			}
			
			if (weaponPossessions[weaponSelection] <= 0) // current weapon not owned: select last one owned
				WeaponDown();
		}
		private function WeaponDown():void
		{
			var ownsOneWeapon:Boolean = false;
			for (var i:Number = 0; i < weaponPossessions.length; ++i)
				if (weaponPossessions[i] > 0) ownsOneWeapon = true;
				
			if (ownsOneWeapon) // if we have an other weapon, we can switch.
			{
				do // while we don't find a weapon that we have
				{
					// go on the previous one
					weaponSelection--;
					if(weaponSelection<0)
						weaponSelection=weaponPossessions.length - 1;
				} while (weaponPossessions[weaponSelection] <= 0 || !weaponIconArray[weaponSelection].visible);
					
				OnSelectedWeaponChanged();
			}
		}
		private function IsEqualToZero(element:*, index:int, arr:Array):Boolean
		{
			return element == 0;
		}
		private function ItemSelectionUnder():void
		{
			backItem.x = itemIconArray[itemSelection].x;
		}
		
		private function WeaponChange(e:InputEvents):void
		{
			var oldSelection:Number = weaponSelection;
			if(e.type==InputEvents.WEAPON_1)
			{
				weaponSelection=0;
			}
			else if(e.type==InputEvents.WEAPON_2)
			{
				weaponSelection=1;
			}
			else if(e.type==InputEvents.WEAPON_3)
			{
				weaponSelection=2;
			}
			else if(e.type==InputEvents.WEAPON_4)
			{
				weaponSelection=3;
			}
			else if(e.type==InputEvents.WEAPON_5)
			{
				weaponSelection=4;
			}
			else if(e.type==InputEvents.WEAPON_6)
			{
				weaponSelection=5;
			}
			if (oldSelection != weaponSelection && // changed weapon
				weaponPossessions[weaponSelection] != 0) // if we have the weapon, we change
			{
				OnSelectedWeaponChanged();
			}
			else
			{
				weaponSelection = oldSelection; // rollback
			}
		}
		private function OnSelectedWeaponChanged():void
		{
			WeaponSelectionUnder();
				
			var inventoryEvent:InventoryEvent = new InventoryEvent(InventoryEvent.SELECTED_WEAPON_CHANGED);
			inventoryEvent.selectedWeaponIndex = weaponSelection;
			dispatchEvent(inventoryEvent);
		}
		private function WeaponSelectionUnder():void
		{
			backWeapon.x = weaponIconArray[weaponSelection].x;
		}

		public function setTutorialSteps(theSteps:Array):void
		{
			tutorialText.setSteps(theSteps);
		}
	}
	
}
