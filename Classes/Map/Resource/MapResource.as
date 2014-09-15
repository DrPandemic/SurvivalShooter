package  {
	import flash.events.Event;

	public class MapResource extends WorldObject {
		private var _captureProgress:ResourceCaptureProgress;
		
		private var _resource:String; // the resource type
		
		private var _millisecsSpentCapturing:Number; // positive = player capture, negative = zombie capture
		private var _millisecsToCapture:Number; // amount of milliseconds to fully capture a resource
		
		
		private static const RESOURCE_QUANTITY_PER_INCOME = 1; // amount of the resource when we receive income
		private var _millisecsForIncome:Number; // amount of milliseconds to receive income from the resource
		
		public var productivityModificator:Number;

		public function MapResource(resource:String,
									millisecondsToCaptureResource:Number,
									millisecondsToEarn1Resource:Number) {
			super(false);
			
			_resource = resource;
			
			_millisecsToCapture = millisecondsToCaptureResource;
			_millisecsSpentCapturing = 0;
			
			_captureProgress = new ResourceCaptureProgress();
			Map.resourceControlContainer.addChild(_captureProgress);
			
			_millisecsForIncome = millisecondsToEarn1Resource;
			
			productivityModificator = 1;
		}
		
		public function positionCaptureProgress():void
		{
			_captureProgress.x = x; // position at top center
			_captureProgress.y = y + -height / 2;
		}
		
		protected function setProgress(amount:Number):void
		{
			_millisecsSpentCapturing = amount * _millisecsToCapture;
			_captureProgress.setProgress(amount);
		}

		public override function onPlayerCollision(player:Player):void
		{
			// Check to update the tutorial based on stepping on a resource
			if (_resource == Inventory.BASE_RESOURCE) 
				Tutorial.onDone(TutorialGoals.CONTROL_BASE_RESOURCE_STEP_OVER_RESOURCE);
			else if (_resource == Inventory.TECH_RESOURCE)
				Tutorial.onDone(TutorialGoals.CONTROL_TECH_STEP_OVER_RESOURCE);
				
			addToCaptureCount(true);
			
			// Check to update the tutorial based on capturing resources
			if (_captureProgress.isOwnedByPlayer())
			{
				if (_resource == Inventory.BASE_RESOURCE)
					Tutorial.onDone(TutorialGoals.CONTROL_BASE_RESOURCE_WAIT_CONTROL_RESOURCE);
				else if (_resource == Inventory.TECH_RESOURCE)
					Tutorial.onDone(TutorialGoals.CONTROL_TECH_WAIT_CONTROL_RESOURCE);
			}
		}
		
		public function onZombieCollision():void
		{
			addToCaptureCount(false);
		}
		
		public function isOwnedByZombie():Boolean
		{
			return _captureProgress.isOwnedByZombie();
		}
		
		private function addToCaptureCount(playerCapture:Boolean)
		{
			// add/remove to our spent capturing the resource based on who is capturing it
			_millisecsSpentCapturing += playerCapture ? 
				GameScreen.MILLISECS_PER_FRAME : -GameScreen.MILLISECS_PER_FRAME;
			
			// We make sure we don't go under our minimum (the zombie capture time) and over our
			// maximum (the player capture time)
			_millisecsSpentCapturing = MathHelper.clamp(_millisecsSpentCapturing,
								 -_millisecsToCapture, _millisecsToCapture);
								 
			// set the progress bar according to the time we've spent capturing it
			setProgress(_millisecsSpentCapturing / _millisecsToCapture); 
		}
		
		public override function update(player:Player, zombies:Array, map:Map):void
		{
			if (_captureProgress.isOwnedByPlayer()) // player owns the resource: get income if we should
			{
				player.inventory.collectResource(_resource, 
					RESOURCE_QUANTITY_PER_INCOME / (_millisecsForIncome / productivityModificator) * GameScreen.MILLISECS_PER_FRAME);
				
				productivityModificator = 1; // reset modificator
			}
		}
		
		public override function isTargetable():Boolean
		{
			return !_captureProgress.isOwnedByZombie();
		}
		
		public function getResourceType():String
		{
			return _resource;
		}
	}
	
}
