package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.motion.Color;
	import flash.text.TextField;
	
	
	public class IconUI extends MovieClip {
		private const DESIRED_DIMENSION:Number = 15;
		
		private var _icon:MovieClip;
		public var index:Number;
		private var _tooltip:ItemTooltip;
		private var _showTooltip:Boolean;
		private var _itemName:String;
		
		public function IconUI() {
			_icon = new MovieClip();
			addChildAt(_icon, 1); // make sure the icon isn't too much in front of everything
			_showTooltip = false;
		}
		
		public function allowTooltip():void
		{
			_showTooltip = true;
			_tooltip = new ItemTooltip();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false,0,true);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			Tutorial.onDone(TutorialGoals.PLACE_WALL_SEE_TOOLTIP);
			parent.addChild(_tooltip); 
			_tooltip.y = y - getBounds(parent).height / 2;
			_tooltip.x = x;
			_tooltip.setItemIcon(ItemDB.GetItem(_itemName));
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			parent.removeChild(_tooltip);
		}
		
		public function setIcon(icon:MovieClip):void
		{
			icon.scaleX = icon.scaleY = DESIRED_DIMENSION / Math.max(icon.width, icon.height);
			_icon.addChild(icon);
		}
		
		public function setTooltipInfo(itemName:String):void
		{
			_itemName = itemName;
			if (_showTooltip)
			{
				_tooltip.setItemName(ItemDB.GetItemName(itemName));
				_tooltip.setItemDescription(ItemDB.GetItemDescription(itemName));
				_tooltip.setBaseCost(CostDB.CostFor(itemName).baseCost);
				_tooltip.setTechCost(CostDB.CostFor(itemName).techCost);
			}
		}
		
		public function destroy():void
		{
			if (_showTooltip)
			{
				removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			removeChild(_icon);
		}
	}
	
}
