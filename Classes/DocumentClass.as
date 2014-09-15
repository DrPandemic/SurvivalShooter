package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;


	public class DocumentClass extends MovieClip
	{
		public static const SCREEN_W:Number = 800;
		public static const SCREEN_H:Number = 450;

		private var gameScreen:GameScreen;
		private var mainMenuScreen:MainMenuScreen;
		private var optionsMenuScreen:OptionsMenuScreen;
		private var tutorialMenuScreen:TutorialMenuScreen;

		private var currentScreen:Screen;
		private var currentLevel:Number;

		private var inMenu:Boolean;

		//Mouse
		private var theMouse:MovieClip;
		private var showNormalMouse:Boolean;
		
		//Sounds
		private var musicBlaster:MusicBlaster;

		public function DocumentClass()
		{
			gameLoaded(null); // later: handle preloader when ready to publish game
		}

		private function gameLoaded(e:Event):void
		{
			//have to init this class one time
			//after we can use var new = InputEventCannon.mainInstance
			var inputCannon = new InputEventCannon();
			addChild(inputCannon);

			inMenu = false;
			currentLevel = 1;

			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.LAUNCH_MENU, launchMenu,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.LAUNCH_GAME, launchGame,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.RESTART_GAME, restartGame,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.LAUNCH_SELECTION, launchSelection,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.LAUNCH_TUTORIAL, launchTutorial,false,0,true);

			//TODO: Uncomment this to start in the menu.
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_MENU));
			//TODO: Remove this to not start in the game.
			//InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_GAME));

			//sounds
			musicBlaster= new MusicBlaster();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,false,0,true);
		}

		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMoved,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.SHOW_NORMAL_MOUSE,showNormalMouse1,false,0,true);
			InputEventCannon.mainInstance.addEventListener(DocumentClassEvent.SHOW_AIM,showAimMouse,false,0,true);

			// Want to profile? uncomment this line and right-click in the game and select "Show Profiler";
			SWFProfiler.init(stage, this);

		}

		private function launchMenu(e:DocumentClassEvent):void
		{
			inMenu = true;
			
			cleanOldScreen();
			
			currentScreen = new MainMenuScreen();
			addChild(currentScreen);
			InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, openOptions,false,0,true);
		}
		private function launchGame(e:DocumentClassEvent):void
		{
			inMenu = false;
			currentLevel = e.level;
			
			cleanOldScreen();
			
			currentScreen = new GameScreen(e.level);
			addChild(currentScreen);
		}
		private function launchSelection(e:DocumentClassEvent):void
		{
			inMenu = false;
			
			cleanOldScreen();
			
			currentScreen = new LevelSelectionScreen();
			addChild(currentScreen);
		}
		private function launchTutorial(e:DocumentClassEvent):void
		{
			inMenu = false;
			cleanOldScreen();
			
			currentScreen = new TutorialMenuScreen();
			addChild(currentScreen);
		}
		private function cleanOldScreen():void
		{
			if (currentScreen!=null)
			{
				currentScreen.destroy();
				removeChild(currentScreen);
				currentScreen = null;
			}
		}
		private function restartGame(e:DocumentClassEvent):void
		{
			InputEventCannon.mainInstance.dispatchEvent(new DocumentClassEvent(DocumentClassEvent.LAUNCH_GAME,currentLevel));
		}
		private function openOptions(e:InputEvents):void
		{
			if (inMenu)
			{
				InputEventCannon.mainInstance.removeEventListener(InputEvents.OPEN_OPTIONS, openOptions);
				optionsMenuScreen = new OptionsMenuScreen(false);
				optionsMenuScreen.addEventListener(InputEvents.OPEN_OPTIONS,removeOptions,false,0,true);

				addChild(optionsMenuScreen);
			}
		}
		private function removeOptions(e:DocumentClassEvent):void
		{
			if (inMenu)
			{
				optionsMenuScreen.removeEventListener(InputEvents.OPEN_OPTIONS,removeOptions);

				removeChild(optionsMenuScreen);
				optionsMenuScreen = null;
				stage.focus = stage;
				
				InputEventCannon.mainInstance.addEventListener(InputEvents.OPEN_OPTIONS, openOptions);
			}
		}
		private function onMouseMoved(e:MouseEvent):void
		{
			if (theMouse != null)
			{
				theMouse.x = e.stageX;
				theMouse.y = e.stageY;
			}
		}
		private function showNormalMouse1(e:Event):void
		{
			if (theMouse!=null)
			{
				stage.removeChild(theMouse);
				theMouse = null;
				Mouse.show();
			}

		}
		private function showAimMouse(e:Event):void
		{
			if (theMouse!=null)
			{
				stage.removeChild(theMouse);
				theMouse = null;
			}
			else
			{
				Mouse.hide();

			}
			theMouse = new MouseAim();
			theMouse.mouseEnabled = false;
			theMouse.mouseChildren = false;
			stage.addChild(theMouse);
		}

	}

}