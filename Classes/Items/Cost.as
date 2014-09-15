package  {
	
	public class Cost{
		
		public var baseCost:Number;
		public var techCost:Number;
		public var progressCost:Number;
		
		public function Cost(_baseCost:Number=0,_techCost:Number=0,_progressCost:Number=0){
			baseCost=_baseCost;
			techCost=_techCost;
			progressCost=_progressCost;
		}
		public function toString()
		{
			return baseCost.toString()+" - "+techCost.toString()+" - "+progressCost.toString();
		}
	}
}