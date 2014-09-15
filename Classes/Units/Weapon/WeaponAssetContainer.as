package  {
	
	import flash.display.MovieClip;
	
	
	public class WeaponAssetContainer extends MovieClip {
		public var weapon:WorldWeapon;
		
		public function WeaponAssetContainer() {
			weapon = null;
		}
		
		public function changeWeaponAsset(weap:WorldWeapon):void
		{
			if (weapon != null)
				removeChild(weapon);
				
			weapon = weap;
			addChild(weap);
		}
	}
	
}
