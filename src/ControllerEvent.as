package
{
	import flash.events.Event;
	
	public class ControllerEvent extends Event
	{
		public static const CONTROLLER_MOVED:String = "CONTROLLER_MOVED";
		public static const CONTROLLER_RELEASED:String = "CONTROLLER_RELEASED";
		public static const CONTROLLER_INITIALIZED:String = "CONTROLLER_INITIALIZED";
		public static const CONTROLLER_LANE_CHANGED:String = "CONTROLLER_LANE_CHANGED";
		public static const CONTROLLER_DEPTH_CHANGED:String = "CONTROLLER_DEPTH_CHANGED";
		public static const CONTROLLER_OWNER_CHANGED:String = "CONTROLLER_OWNER_CHANGED";
		
		private var _controller:Controller;
		
		public function ControllerEvent(type:String, controller:Controller)
		{
			super(type, false, false);
			_controller = controller;
		}
		
		public function get controller():Controller {
			return _controller;
		}
	}
}