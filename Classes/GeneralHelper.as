package  {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class GeneralHelper {
		
		//because fuck you flash
		public function GenralHelper() {
			// constructor code
		}
		public static function clone(obj : *):*
		{
			return new (classOf(obj))();
		}
		public static function classOf(obj:*):Class
		{
			return getDefinitionByName(getQualifiedClassName(obj)) as Class;
		}
	}
	
}
