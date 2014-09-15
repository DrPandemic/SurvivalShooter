package  {
	
	import flash.display.MovieClip;
	
	
	public class ShopItemCost extends MovieClip {
		
		
		public function ShopItemCost(baseCost:int, techCost:int) {
			baseAmount.text = baseCost.toString();
			techAmount.text = techCost.toString();
		}
	}
	
}
