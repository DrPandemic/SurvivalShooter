package  {

	public class ItemDB {
		
		
		public function ItemDB() {
			
		}
		public static function GetItemClass(str:String):Class
		{
			switch (str)
			{
			//Ammo
			case Inventory.AMMO:
			return Ammo as Class;
			break;			
			case Inventory.AMMO2:
			return Ammo2 as Class;
			break;
			
			//Weapons
			case Inventory.KNIFE_WEAPON:
			return Knife as Class;
			break;			
			case Inventory.HANDGUN_WEAPON:
			return HandGun as Class;
			break;			
			case Inventory.MACHINE_GUN_WEAPON:
			return MachineGun as Class;
			break;			
			case Inventory.SHOTGUN_WEAPON:
			return ShotGun as Class;
			break;			
			case Inventory.SNIPER_WEAPON:
			return Sniper as Class;
			break;
			case Inventory.FIRE_WAVE:
			return FireWave as Class;
			break;
			
			//Items
			case Inventory.ROCK_WALL:
			return RockWall as Class;
			break;
			case Inventory.BRICK_WALL:
			return BrickWall as Class;
			break;
			case Inventory.AUTO_TURRET:
			return AutoTurret as Class;
			break;
			case Inventory.SPIKE_TRAP:
			return SpikeTrap as Class;
			break;
			case Inventory.PROD_BOOSTER:
			return ProdBooster as Class;
			break;
			case Inventory.PROGRESS_RESOURCE:
			return ProgressResource as Class;
			break;

			
			default:
			throw new Error("Try to find the class of an non-existing object");
			}
		}
		public static function GetItem(str:String):Item
		{
			switch (str)
			{
			//Ammo
			case Inventory.AMMO:
			return new Ammo(str);
			break;		
			case Inventory.AMMO_20:
			return new Ammo(str);
			break;			
			case Inventory.AMMO_50:
			return new Ammo(str);
			break;			
			case Inventory.AMMO_100:
			return new Ammo(str);
			break;			
			case Inventory.AMMO2:
			return new Ammo2(str);
			break;
			case Inventory.AMMO2_20:
			return new Ammo2(str);
			break;
			case Inventory.AMMO2_50:
			return new Ammo2(str);
			break;
			case Inventory.AMMO2_100:
			return new Ammo2(str);
			break;
			
			
			//Weapons
			case Inventory.KNIFE_WEAPON:
			return new Knife();
			break;			
			case Inventory.HANDGUN_WEAPON:
			return new HandGun();
			break;			
			case Inventory.MACHINE_GUN_WEAPON:
			return new MachineGun();
			break;			
			case Inventory.SHOTGUN_WEAPON:
			return new ShotGun();
			break;			
			case Inventory.SNIPER_WEAPON:
			return new Sniper();
			break;
			case Inventory.FIRE_WAVE:
			return new FireWave();
			break;
			
			//Items
			case Inventory.ROCK_WALL:
			return new RockWall();
			break;
			case Inventory.BRICK_WALL:
			return new BrickWall();
			break;
			case Inventory.AUTO_TURRET:
			return new AutoTurret();
			break;
			case Inventory.SPIKE_TRAP:
			return new SpikeTrap();
			break;
			case Inventory.PROD_BOOSTER:
			return new ProdBooster();
			break;
			case Inventory.PROGRESS_RESOURCE:
			return new ProgressResource();
			break;

			
			default:
			throw new Error("Try to create an object of an non-existing class");
			}
		}
		
		public static function GetItemIngameWorldObject(itemName:String):WorldObject
		{
			switch (itemName)
			{
			//Ammos have no world object items: that's an error
			case Inventory.AMMO:
			case Inventory.AMMO2:
			throw new Error("Ammos shouldn't be represented as world objects from this function.");
			break;
			
			case Inventory.KNIFE_WEAPON:
			return new KnifeWeapon();
			break;
			case Inventory.HANDGUN_WEAPON:
			return new HandgunWeapon();
			break;
			case Inventory.MACHINE_GUN_WEAPON:
			return new MachinegunWeapon();
			break;
			case Inventory.SHOTGUN_WEAPON:
			return new ShotgunWeapon();
			break;
			case Inventory.SNIPER_WEAPON:
			return new SniperWeapon();
			break;
			case Inventory.FIRE_WAVE:
			return new FireWaveWeapon();
			break;
			
			//Items
			case Inventory.ROCK_WALL:
			return new RockWallMapObject();
			break;
			case Inventory.BRICK_WALL:
			return new BrickWallMapObject();
			break;
			case Inventory.AUTO_TURRET:
			return new AutoTurretMapObject();
			break;
			case Inventory.SPIKE_TRAP:
			return new SpikeTrapMapObject();
			break;
			case Inventory.PROD_BOOSTER:
			return new ProductivityBoosterMapObject();
			break;
			case Inventory.PROGRESS_RESOURCE:
			return new ProgressMapResource(true);
			break;

			
			default:
			throw new Error("Trying to create an object of an non-existing class");
			}
		}
		
		public static function GetItemName(name:String):String
		{
			switch (name)
			{
				case Inventory.ROCK_WALL: return "Brick Wall";
				case Inventory.BRICK_WALL: return "Fence";
				case Inventory.SPIKE_TRAP: return "Spike Trap";
				case Inventory.AUTO_TURRET: return "Auto Turret";
				case Inventory.PROD_BOOSTER: return "Production Booster";
				case Inventory.PROGRESS_RESOURCE: return "Progress Resource";
				
				case Inventory.KNIFE_WEAPON: return "Hammer";
				case Inventory.HANDGUN_WEAPON: return "Handgun";
				case Inventory.MACHINE_GUN_WEAPON: return "Assault Riffle";
				case Inventory.SHOTGUN_WEAPON: return "Shotgun";
				case Inventory.SNIPER_WEAPON: return "Sniper";
				case Inventory.FIRE_WAVE: return "Grenades";
				
				default: throw new Error("Invalid item name.");
			}
		}
		
		// Returns the level required to be able to buy/use/see something
		public static function GetLevelToUnlock(name:String):Number
		{
			switch (name)
			{
				case Inventory.KNIFE_WEAPON:
				case Inventory.HANDGUN_WEAPON:
				case Inventory.AMMO: case Inventory.AMMO_20: case Inventory.AMMO_50: case Inventory.AMMO_100:
				case Inventory.ROCK_WALL:
					return 1;
					
				case Inventory.MACHINE_GUN_WEAPON:
				case Inventory.SHOTGUN_WEAPON:
				case Inventory.BRICK_WALL:
					return 2;
					
				case Inventory.PROGRESS_RESOURCE:
					return 3;
					
				case Inventory.SPIKE_TRAP:
				case Inventory.AUTO_TURRET:
					return 4;
					
				case Inventory.SNIPER_WEAPON:
				case Inventory.AMMO2: case Inventory.AMMO2_20: case Inventory.AMMO2_50: case Inventory.AMMO2_100:
				case Inventory.PROD_BOOSTER:
					return 5;
					
				case Inventory.FIRE_WAVE:
					return 6;
				
				default: throw new Error("Invalid item name.");
			}
		}
		
		public static function GetLevelToUnlockUI(uiName:String):Number
		{
			switch (uiName)
			{
				case Inventory.BASE_RESOURCE:
				case Inventory.PROGRESS_RESOURCE:
				case Inventory.KILL_RESOURCE:
					return 1;
					
				case Inventory.TECH_RESOURCE:
					return 2;
					
				case Inventory.AMMO2:
					return 5;
					
				default: throw new Error("Invalid UI element name.");
			}
		}
		
		public static function GetItemDescription(name:String):String
		{
			switch (name)
			{
				case Inventory.ROCK_WALL: return "A wall made of bricks to block enemies.";
				case Inventory.BRICK_WALL: return "A fence that blocks enemies, but lets bullets go through it.";
				case Inventory.SPIKE_TRAP: return "A trap that hurts and slows enemies going on it.";
				case Inventory.AUTO_TURRET: return "A turret that uses your ammo to shoot enemies in its view.";
				case Inventory.PROD_BOOSTER: return "Increases the production speed of the resources in its range by " + (ProductivityBoosterMapObject.PRODUCTIVITY_BOOST * 100).toString() + "%.";
				case Inventory.PROGRESS_RESOURCE: return "Collects progress resources to make you clear a level.";
				
				case Inventory.KNIFE_WEAPON: return "A close-combat hammer. It can be used to break your walls. You run faster with it.";
				case Inventory.HANDGUN_WEAPON: return "A regular handgun. Semi-automatic. Uses regular ammo.";
				case Inventory.MACHINE_GUN_WEAPON: return "An assault riffle that shoots fast. Automatic. Uses regular ammo.";
				case Inventory.SHOTGUN_WEAPON: return "A shotgun that shoots 3 bullets in a cone. Semi-automatic. Uses regular ammo.";
				case Inventory.SNIPER_WEAPON: return "A sniper that shoots through enemies. Semi-automatic. Uses high ammo.";
				case Inventory.FIRE_WAVE: return "A grenade that explodes on contact. You can stack grenades.";
				
				default: throw new Error("Invalid item name.");
			}
		}
	}
}