package
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	// Singleton Controllers Class
	public class ControllerManager extends EventDispatcher
	{
		// Class Variables For Singleton Implementation
		private static var allowInst:Boolean;
		private static var _instance:ControllerManager;
		
		// CONSTANTS
		public static const CONTROLLER_COUNT:uint = 4;
		public static const DEPTH_COUNT:uint = 5;
		public static const ATT_RADIUS:uint = 15;
		public static const LOCAL_LANE_COUNT:uint = 8;

		// DATA
		public var controllers:Vector.<Controller>;
		
		public function ControllerManager()
		{
			if (!allowInst) {
				throw new Error("Error: Instantiation failed: Use sensorDataListener.getInstance() instead of new.");
			}
			else
			{
				controllers = new Vector.<Controller>;
				
				//initialize controller
				for (var i:Number = 0; i<CONTROLLER_COUNT; i++)
					controllers.push(new Controller(i,Floor.WIDTH/CONTROLLER_COUNT*(i+0.5),450));
				
				//initialize event-listeners
				People.getInstance().addEventListener(PeopleEvent.PERSON_ADDED,onPersonAdded);
				People.getInstance().addEventListener(PeopleEvent.PERSON_MOVED,onPersonMoved);
				People.getInstance().addEventListener(PeopleEvent.PERSON_REMOVED,onPersonRemoved);
				
				for each(var controller:Controller in controllers){
					controller.addEventListener(ControllerEvent.CONTROLLER_LANE_CHANGED,laneChanged);
					controller.addEventListener(ControllerEvent.CONTROLLER_DEPTH_CHANGED,depthChanged);
					controller.addEventListener(ControllerEvent.CONTROLLER_INITIALIZED, controllerInitiated);
					controller.addEventListener(ControllerEvent.CONTROLLER_RELEASED, controllerReleased);
				}
			}
		}
		
		protected function controllerInitiated(event:Event):void
		{
			var controller:Controller = event.target as Controller;
			controller.effect.reset();
			controller.effect.initializedEffect();
			trace('controller initialized at Controller ' + event.target.id);			
		}
		
		protected function controllerReleased(event:Event):void
		{
			var controller:Controller = event.target as Controller;
			controller.effect.reset();
			trace('controller released at Controller ' + event.target.id);			
		}
		
		protected function depthChanged(event:Event):void
		{
			var controller:Controller = event.target as Controller;
		}
		
		protected function laneChanged(event:Event):void
		{
			var controller:Controller = event.target as Controller;
		}
		
		public static function init():ControllerManager {
			if(_instance == null){
				allowInst = true;
				_instance = new ControllerManager();
				allowInst = false;
			}
			return _instance;
		}
		
		public static function getInstance():ControllerManager {
			if(_instance == null){
				throw new Error("Please initialize with method init(...) first!");
			}
			return _instance
		}
		
		private function onPersonAdded(e:PeopleEvent):void {
//			trace("Handling Event:",e.type);
			VoronoiDrawer.getInstance().update();
			var person:Person = e.person;
			for each (var controller:Controller in controllers) {
				if (distance(person,controller) < ATT_RADIUS) {
					controller.Owner = person;
					//trace(controller);
					controller.moveTo(person.x,person.y);
					break;
				}
			}
		}
		
		private function onPersonMoved(e:PeopleEvent):void {
//			trace("Handling Event:",e.type);
			var person:Person = e.person;
			VoronoiDrawer.getInstance().update();
			for each (var controller:Controller in controllers) {
				// switch to another controller
				if ((controller.Owner == null) && (distance(person,controller) < ATT_RADIUS)) {
					var ownedController:Controller = findByOwner(person);
					if (ownedController!=null) ownedController.reset(); 
					controller.Owner = person;
					controller.moveTo(person.x,person.y);

					return;
				}
			}
			var myController:Controller = findByOwner(person);
			if (myController!=null)
				myController.moveTo(person.x,person.y);
		}
		
		private function onPersonRemoved(e:PeopleEvent):void {
//			trace("Handling Event:",e.type);
			var person:Person = e.person;
			VoronoiDrawer.getInstance().update();
			for each (var controller:Controller in controllers) {
				if (controller.Owner == null) continue;
				if (controller.Owner == person) {
					controller.reset();
					//trace(controller);
					
					return;
				}
			}
		}
		
		private function findByOwner(owner:Person):Controller {
			for each (var controller:Controller in controllers) {
				if (controller.Owner == owner)
					return controller;
			}
			return null;
		}
		
		private function distance(a:DisplayObject, b:DisplayObject):Number {
			return Math.sqrt(((a.x - b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y)));
		}
	}
}