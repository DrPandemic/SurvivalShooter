package  {
	
	import flash.display.MovieClip;
	import flash.text.StyleSheet;
	import fl.motion.Color;
	import flash.text.TextField;
	
	
	public class TutorialStepsText extends MovieClip {
		private var oldHtml:String;
		
		public function TutorialStepsText() {
			oldHtml = null;
		}
		
		public function setSteps(steps:Array):void
		{
			if (steps.length > 0 && // we still have steps to do on the current level
				steps[0].length > 1) // our current tutorial step has sub-steps to do
			{
				visible = true;
				var currentSteps:Array = steps[0]; // we go with the easiest steps first (the first ones)
				var theHtml:String = "<p>" + currentSteps[0] + "</p>";
				
				// start at one since the first once is already written
				theHtml = theHtml.concat("<li>" + currentSteps[1] + "</li>");
				
				if (theHtml != oldHtml) // if we actually changed something
				{
					var css:StyleSheet = new StyleSheet();
					css.parseCSS("li { color: #FFFFFF; }");
				
					tutorialText.htmlText = theHtml; 
					tutorialText.styleSheet = css;
					
					oldHtml = new String(theHtml);
				}
			}
			else // no tutorial? hide the window
			{
				visible = false;
			}
		}
	}
	
}
