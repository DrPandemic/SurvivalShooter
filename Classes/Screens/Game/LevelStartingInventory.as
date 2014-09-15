package  {
	
	public class LevelStartingInventory {

		public function LevelStartingInventory() {
		}

		public function fillInventoryForLevel(inventory:Inventory, level:Number):void
		{
			switch (level)
			{
				case 1: break;
				
				case 2: 
					inventory.collectResources(CostDB.CostFor(Inventory.ROCK_WALL), 3);
					
					inventory.collectResources(CostDB.CostFor(Inventory.BRICK_WALL), 2);
					break;
					
				case 3:
					inventory.acquireWeapon(Inventory.HANDGUN_WEAPON);
					break;
					
				case 4:
					inventory.acquireWeapon(Inventory.HANDGUN_WEAPON);
					break;
					
				case 5:
					inventory.acquireWeapon(Inventory.HANDGUN_WEAPON);
					break;
					
				case 6:
					inventory.acquireWeapon(Inventory.SHOTGUN_WEAPON);
					break;
					
				case 7:
					inventory.collectResources(CostDB.CostFor(Inventory.AUTO_TURRET));
					break;
					
				case 8:
					inventory.acquireWeapon(Inventory.HANDGUN_WEAPON);
					inventory.collectAmmo(Inventory.FIRE_WAVE, 3);
				
					inventory.collectResources(CostDB.CostFor(Inventory.SPIKE_TRAP));
					break;
					
				case 9: break;
					
				case 10: break;
				
				default: throw new Error("Level " + level.toString() + " is not implemented while filling inventory.");
			}
		}
	}
	
}
