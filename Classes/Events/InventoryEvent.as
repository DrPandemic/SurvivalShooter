package  {
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class InventoryEvent extends Event {
		public static const SELECTED_ITEM_CHANGED:String = "SelectedItemChanged";
		public static const ITEM_QUANTITIES_CHANGED:String = "ItemQuantitiesChanged";
		
		public static const SELECTED_WEAPON_CHANGED:String = "SelectedWeaponChanged";
		public static const WEAPON_POSSESSIONS_CHANGED:String = "WeaponPossessionsChanged";

		public var items:Array; // This is a list of the QUANTITIES of every item, ordered by its position on the UI
		public var selectedItemIndex:Number;
		
		public var weapons:Array; // This is a list of the possession of every weapon, ordered by its position on the UI
		public var selectedWeaponIndex:Number;

		public function InventoryEvent(eventName:String) {
			super(eventName);
			items = null;
			weapons = null;
			selectedItemIndex = -1;
			selectedWeaponIndex = -1;
		}
	}
	
}
