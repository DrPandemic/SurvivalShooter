package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	
	public class ItemTooltip extends MovieClip {
		
		
		public function ItemTooltip() {
			// constructor code
		}
		
		public function setItemName(name:String):void
		{
			ItemName.text = name;
		}
		
		public function setItemDescription(description:String):void
		{
			ItemDescription.text = description;
		}
		
		public function setItemIcon(icon:MovieClip):void
		{
			icon.width = icon.height = 49;
			icon.x = icon.y = 0;
			IconContainer.addChild(icon);
		}
		
		public function setBaseCost(cost:Number):void
		{
			BaseCost.text = cost.toString();
		}
		
		public function setTechCost(cost:Number):void
		{
			TechCost.text = cost.toString();
		}
	}
	
}
