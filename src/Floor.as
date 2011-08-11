package 
{
	import flash.display.Sprite;
	
	public class Floor extends Sprite
	{
		// Class Variables For Singleton Implementation
		private static var allowInst:Boolean;
		private static var _instance:Floor;
		
		public static const WIDTH:Number = 1024;
		public static const HEIGHT:Number = 480;
		
		// Instance Variables
		public function Floor()
		{
			if (!allowInst) {
				throw new Error("Error: Instantiation failed: Use sensorDataListener.getInstance() instead of new.");
			}
			else
			{
			}
		}
		
		public static function init():Floor {
			if(_instance == null){
				allowInst = true;
				_instance = new Floor();
				allowInst = false;
			}
			return _instance;
		}
		
		public static function getInstance():Floor {
			if(_instance == null){
				throw new Error("Please initialize with method init(...) first!");
			}
			return _instance
		}
		
		
		
	}
}