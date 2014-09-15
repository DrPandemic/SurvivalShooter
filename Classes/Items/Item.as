package  {
	
	import flash.display.MovieClip;

	
	public class Item extends MovieClip {
		static public const WEAPON:String = "Weapon";
		static public const WALL:String = "Wall";
		static public const TECH:String = "Tech";
		
		protected var _kind:String;
		protected var _cost:Cost;
		protected var _image:MovieClip;
		
		public function Item(theKind:String) {
			_kind = theKind;
			_cost=CostDB.CostFor(theKind);
			addChild(_image);
			_image.gotoAndStop(3);
			
		}
		public function get kind():String
		{		
			return _kind;
		}
		public function get cost():Cost
		{
			return _cost;
			
		}
		public function get image():MovieClip
		{
			if(_image!=null)
				return _image;
			throw new Error("Image in an item wasn't init");
		}
	}
	
}

