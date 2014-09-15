package  {
	
	public class CostDB {

		public function CostDB() {
		
		}
		static function CostFor(item:String):Cost
		{
			switch (item)
			{
			//Ammo
			case Inventory.AMMO:
			return new Cost(0);
			break;
			case Inventory.AMMO_20:
			return new Cost(15);
			break;
			case Inventory.AMMO_50:
			return new Cost(35);
			break;
			case Inventory.AMMO_100:
			return new Cost(65);
			break;
			case Inventory.AMMO2:
			return new Cost(0);
			break;
			case Inventory.AMMO2_20:
			return new Cost(10,10);
			break;
			case Inventory.AMMO2_50:
			return new Cost(20,20);
			break;
			case Inventory.AMMO2_100:
			return new Cost(35,35);
			break;
			
			//Weapons
			case Inventory.KNIFE_WEAPON:
			return new Cost();
			break;			
			case Inventory.HANDGUN_WEAPON:
			return new Cost(20);
			break;			
			case Inventory.MACHINE_GUN_WEAPON:
			return new Cost(40,40);
			break;			
			case Inventory.SHOTGUN_WEAPON:
			return new Cost(70,10);
			break;			
			case Inventory.SNIPER_WEAPON:
			return new Cost(100,100);
			break;
			case Inventory.FIRE_WAVE:
			return new Cost(5,20);
			break;
			
			//Items
			case Inventory.ROCK_WALL:
			return new Cost(5);
			break;
			case Inventory.BRICK_WALL:
			return new Cost(10,2);
			break;
			case Inventory.AUTO_TURRET:
			return new Cost(40,30);
			break;
			case Inventory.SPIKE_TRAP:
			return new Cost(20,30);
			break;
			case Inventory.PROD_BOOSTER:
			return new Cost(40,40);
			break;
			case Inventory.PROGRESS_RESOURCE:
			return new Cost(200, 50);
			
			default:
			throw new Error("Try to find cost of an non-existing object");
			}
		}

	}
	
}
