package  {
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import fl.motion.Color;
	
	
	public class ResourceOutput extends MovieClip {
		public static const BASE_COLOR:uint = 0x0066FF;
		public static const TECH_COLOR:uint = 0x009900;
		public static const PROGRESS_COLOR:uint = 0xFFCC00;
		public static const PROGRESS_COMPLETE_COLOR:uint = PROGRESS_COLOR;
		public static const KILL_COLOR:uint = 0xFF0000;
		public static const KILL_COMPLETE_COLOR:uint = KILL_COLOR;
		
		public function ResourceOutput() {
			textArea.text="0";
		}
		
		/// Sets the color of the resource amount text
		public function setColor(color:uint):void
		{
			textArea.textColor = color;
		}
		
		/// Returns the dimensions of the text area representing the resource
		/// output.
		public function getWidth():Number
		{
			return textArea.textWidth;
		}
		public function getHeight():Number
		{
			return textArea.height;
		}
		
		/// Sets the amount of resource text.
		public function setAmount(amount:String):void
		{
			textArea.text = amount;
		}
	}
	
}
