package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;


	//to do, placer le carré
	
	public class ShopItemButton extends MovieClip {
		
		private const DESIRED_ICON_DIMENSION:Number = 20;
		public static const DIMENSION:Number = 25;
		
		public var _iconImage:Item;
		
		
		
		public function ShopItemButton(iconImage:Item,amount:Number = 1) {
			
			_iconImage=iconImage;
			_iconImage.scaleX = _iconImage.scaleY = 
				DESIRED_ICON_DIMENSION / Math.max(_iconImage.width, _iconImage.height);
			
			addChild(_iconImage);
			
			if(amount>1)
			{
				var amountDisplay:TextField = new TextField();			
				var textFormat:TextFormat = new TextFormat();
				textFormat.size=18;
				amountDisplay.defaultTextFormat=textFormat;
				amountDisplay.text=amount.toString();
				amountDisplay.selectable = false;
				
				amountDisplay.x-=10;
				amountDisplay.y-=10;
				
				addChild(amountDisplay);
			}
			
			buttonMode=true;
			mouseChildren = false;
			doubleClickEnabled = true;
			addEventListener(MouseEvent.CLICK, onClick,false,0,true);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick,false,0,true);
		}

		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new ShopEvent(_iconImage,ShopEvent.SELECT));
		}
		private function onDoubleClick(e:MouseEvent):void
		{
			dispatchEvent(new ShopEvent(_iconImage,ShopEvent.BUY));
		}

	}
	
}
