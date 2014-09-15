package  {
	import flash.utils.Dictionary;
	
	public class TutorialGoals {
		// Level 1
		private const MOVE:String = "Get It Moving";
		public static const MOVE_WALK:String = "Walk with 'WASD'";
		public static const MOVE_RUN:String = "Run by double-tapping a key";
		
		private const ATTACK:String = "A Hit In The Dark";
		public static const ATTACK_KNIFE:String = "'LEFT-CLICK' to attack with your knife";
		
		private const CONTROL_BASE_RESOURCE:String = "Getting Some Income";
		public static const CONTROL_BASE_RESOURCE_STEP_OVER_RESOURCE:String = "Step over a rock resource.";
		public static const CONTROL_BASE_RESOURCE_WAIT_CONTROL_RESOURCE:String = "Stay over the resource until you capture it to gain periodic income.";
		public static const CONTROL_BASE_RESOURCE_WAIT_FOR_ENOUGH_RESOURCES_FOR_GUN:String = "Wait until you have 20 rock resources. You can move.";
		
		private const BUY_GUN:String = "Weaponery In The Bank";
		public static const BUY_GUN_OPEN_SHOP:String = "Open the shop with 'E'";
		public static const BUY_GUN_CLICK_HANDGUN:String = "Click on the handgun icon.";
		public static const BUY_GUN_CLICK_BUY:String = "Click on \"buy\" to buy the item.";
		
		private const SELECT_GUN:String = "Don't Bring A Hammer To A Gunfight";
		public static const SELECT_GUN_CHANGE_IT:String = "Press a number to change weapon (e.g. '2') or click on its icon.";
		
		private const PLACE_WALL:String = "Blocking The Way";
		public static const PLACE_WALL_SEE_TOOLTIP:String = "Put your mouse above an item to see its price and description.";
		public static const PLACE_WALL_BUILD_MODE:String = "Start the \"build mode\" by pressing 'Q'";
		public static const PLACE_WALL_BUILD:String = "'LEFT-CLICK' to build at a valid emplacement.";
		
		private const HURT_WALL:String = "Breaking Your Own Defense";
		public static const HURT_WALL_HIT_WALL:String = "Hit one of your walls with your hammer to hurt it (if you ever get stuck).";
		
		private const BUY_AMMO:String = "Load The Guns";
		public static const BUY_AMMO_OPEN_SHOP = "Open the shop with 'E'.";
		public static const BUY_AMMO_CLICK_AMMO = "Select one of the ammo deals.";
		public static const BUY_AMMO_BUY_AMMO = "Buy one of the ammo deals.";
		
		private const DEFEND:String = "Defend Your Ground";
		public static const DEFEND_COLLECT_ENOUGH_PROGRESS:String = "Defend your progress resource long enough to complete the level.";



		// Level 2
		private const PLACE_BARRIER:String = "A Barrier Between You And Me";
		public static const PLACE_BARRIER_SELECT_IT:String = "Select the barrier by clicking on its icon or by 'SCROLLING' with the mouse.";
		public static const PLACE_BARRIER_BUILD_IT:String = "Build a barrier. Bullets can go through them.";
		
		private const CONTROL_TECH:String = "Getting Technologic";
		public static const CONTROL_TECH_STEP_OVER_RESOURCE:String = "Go over a gaz resource to control it.";
		public static const CONTROL_TECH_WAIT_CONTROL_RESOURCE:String = "This gives your tech income to build higher-tier items.";

		private const BUY_TIER2_WEAPON:String = "The Gun Was Fun, But Let's Get Serious";
		public static const BUY_TIER2_WEAPON_OPEN_SHOP:String = "Open the shop ('E').";
		public static const BUY_TIER2_WEAPON_SELECT_WEAPON:String = "Select a machinegun or a shotgun by clicking on its icon.";
		public static const BUY_TIER2_WEAPON_BUY_IT:String = "Buy one of them.";
		
		
		
		// Level 3
		private const CONTROL_PROGRESS:String = "Progressing By Yourself";
		public static const CONTROL_PROGRESS_WAIT_FOR_ENOUGH:String = "Collect enough resources to build a progress resource by yourself.";
		public static const CONTROL_PROGRESS_BUILD_IT:String = "Select and build the progress resource (the last item on the item bar).";
		
		
		
		// Level 4
		private const PLACE_TIER2_ITEMS:String = "Walls May Be Useful, But Traps Are Even Better";
		public static const PLACE_TIER2_ITEMS_BUILD:String = "Build either a spiketrap or an auto turret.";
		
		
		
		// Level 5
		private const UNBUILDABLE_TILES:String = "Can't Build Anywhere You Want Anymore";
		public static const UNBUILDABLE_TILES_BUILD_MODE:String = "You can't build on some spots. You'll notice when you build something.";
		
		private const BUY_SNIPER:String = "Most Of The Fun Comes From Bigger Guns";
		public static const BUY_SNIPER_BUY_IT:String = "Buy a sniper from the shop ('E'). It uses an other type of ammo.";
		public static const BUY_SNIPER_BUY_AMMO:String = "Buy high ammo from the shop. They pierce through enemies.";
		
		
		
		// Level 6
		private const GRENADE:String = "Grenades For The Pyromaniacs";
		public static const GRENADE_BUY:String = "Buy a grenade from the shop. They stack.";
		public static const GRENADE_SHOOT:String = "Shoot a grenade. It explodes on contact.";
		
		// Every key represents the level of the tutorial text.
		// The value is an array of the steps of a tutorial.
		// Each step is an array with the first element being the primary goal, and the other elements being
		// the secondary goals.
		// e.g.
		// [1] -> Array(
		//            Array("Move",
		//			            "Walk with 'WASD'",
		//						"Run by double-tapping")
		//			  Array("etc...")
		//        )
		// [2] -> ...
		private var thingsToDo:Dictionary;

		public function TutorialGoals() {
			initThingsToDo();
		}
		
		private function initThingsToDo():void
		{
			thingsToDo = new Dictionary();
			
			thingsToDo[1] = new Array(
			  new Array(MOVE,
							MOVE_WALK,
							MOVE_RUN),
			  new Array(ATTACK,
							ATTACK_KNIFE),
			  new Array(CONTROL_BASE_RESOURCE,
							CONTROL_BASE_RESOURCE_STEP_OVER_RESOURCE,
							CONTROL_BASE_RESOURCE_WAIT_CONTROL_RESOURCE,
							CONTROL_BASE_RESOURCE_WAIT_FOR_ENOUGH_RESOURCES_FOR_GUN),
			  new Array(BUY_GUN,
							BUY_GUN_OPEN_SHOP,
							BUY_GUN_CLICK_HANDGUN,
							BUY_GUN_CLICK_BUY),
			  new Array(SELECT_GUN,
							SELECT_GUN_CHANGE_IT),
			  new Array(PLACE_WALL, 
							PLACE_WALL_SEE_TOOLTIP,
							PLACE_WALL_BUILD_MODE, 
							PLACE_WALL_BUILD), 
			  new Array(HURT_WALL, 
							HURT_WALL_HIT_WALL), 
			  new Array(BUY_AMMO, 
							BUY_AMMO_OPEN_SHOP, 
							BUY_AMMO_CLICK_AMMO, 
							BUY_AMMO_BUY_AMMO), 
			  new Array(DEFEND, 
							DEFEND_COLLECT_ENOUGH_PROGRESS) // This one is never achieved, so it is not fired
									  );
									  
			thingsToDo[2] = new Array(
			  new Array(PLACE_BARRIER,
							PLACE_BARRIER_SELECT_IT,
							PLACE_BARRIER_BUILD_IT),
			  new Array(CONTROL_TECH,
							CONTROL_TECH_STEP_OVER_RESOURCE,
							CONTROL_TECH_WAIT_CONTROL_RESOURCE),
			  new Array(BUY_TIER2_WEAPON,
							BUY_TIER2_WEAPON_OPEN_SHOP,
							BUY_TIER2_WEAPON_SELECT_WEAPON,
							BUY_TIER2_WEAPON_BUY_IT)
									  );
									  
			thingsToDo[3] = new Array(
			  new Array(CONTROL_PROGRESS,
							CONTROL_PROGRESS_WAIT_FOR_ENOUGH,
							CONTROL_PROGRESS_BUILD_IT)
									  );
									  
			thingsToDo[4] = new Array(
			  new Array(PLACE_TIER2_ITEMS,
							PLACE_TIER2_ITEMS_BUILD)
									  );
									  
			thingsToDo[5] = new Array(
			  new Array(UNBUILDABLE_TILES,
							UNBUILDABLE_TILES_BUILD_MODE),
			  new Array(BUY_SNIPER,
							BUY_SNIPER_BUY_IT,
							BUY_SNIPER_BUY_AMMO)
									 );
									 
			thingsToDo[6] = new Array(
			  new Array(GRENADE,
							GRENADE_BUY,
							GRENADE_SHOOT)
									 );
						
		}
		
		public function markAsCompleted(level:Number, action:String):void
		{
			if (thingsToDo[level] != undefined && thingsToDo[level].length > 0) // the level has tutorial text in it
			{
				for each (var tutorialStep:Array in thingsToDo[level])
				{
					if (tutorialStep.indexOf(action) > 0) // if the action is not yet completed,
						tutorialStep.splice(tutorialStep.indexOf(action), 1); // mark it as completed by removing it
						
					if (tutorialStep.length <= 1) // if we finished all the things of the current step (the first element is the title, so <= 1)
						thingsToDo[level].splice(thingsToDo[level].indexOf(tutorialStep), 1); // remove the step, we're done with it
				}
				
				if (thingsToDo[level].length == 0) // if we're done with the steps for the level,
					thingsToDo[level] = undefined; // we can remove it from our tutorial
			}
		}
		
		public function getTutorialSteps(level:Number):Array
		{
			if (thingsToDo[level] != undefined) // If we do have tasks on that level
				return thingsToDo[level];
			else // if it's not defined, return no data to show at all
				return new Array();
		}
		
		public function getCurrentTutorialStep(level:Number):String
		{
			var steps:Array = getTutorialSteps(level);
			
			if (steps.length == 0) return ""; // no tutorial to follow? exit
			
			var currentSteps:Array = steps[0]; // take the next step that we'll have to do
			if (currentSteps.length <= 1) return ""; // only the title in it or no steps at all? exit
			else return currentSteps[1]; // element 1 is the title, so return the text of the first thing to do (skip the title)
		}
	}
	
}
