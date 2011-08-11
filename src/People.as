package
{
	import de.polygonal.ds.HashMap;
	
	import flash.events.EventDispatcher;
	
	import org.tuio.ITuioListener;
	import org.tuio.TuioBlob;
	import org.tuio.TuioCursor;
	import org.tuio.TuioObject;

	// Singleton People Class
	public class People extends EventDispatcher implements ITuioListener
	{
		// Class Variables For Singleton Implementation
		private static var allowInst:Boolean;
		private static var _instance:People;
		
		private static const FLOOR_WIDTH:Number = Floor.WIDTH;
		private static const FLOOR_HEIGHT:Number = Floor.HEIGHT;
		
		// Instance Variables
		public var peopleMap:HashMap;
		
		public function People()
		{
			if (!allowInst) {
				throw new Error("Error: Instantiation failed: Use sensorDataListener.getInstance() instead of new.");
			}
			else
			{
				peopleMap = new HashMap();
			}
		}
		
		public static function init():People {
			if(_instance == null){
				allowInst = true;
				_instance = new People();
				allowInst = false;
			}
			return _instance;
		}
		
		public static function getInstance():People {
			if(_instance == null){
				throw new Error("Please initialize with method init(...) first!");
			}
			return _instance
		}
		
		public function addTuioCursor(tuioCursor:TuioCursor):void
		{
			var person:Person = new Person(tuioCursor.sessionID, tuioCursor.x*FLOOR_WIDTH, tuioCursor.y*FLOOR_HEIGHT);
			Floor.getInstance().addChild(person);
			peopleMap.set(tuioCursor.sessionID,person);
			//trace("PERSON_ADDED::",person);
			dispatchEvent(new PeopleEvent(PeopleEvent.PERSON_ADDED,person));
			
		}
		
		public function removeTuioCursor(tuioCursor:TuioCursor):void
		{
			var person:Person = peopleMap.get(tuioCursor.sessionID) as Person;
			Floor.getInstance().removeChild(person);
			peopleMap.clr(tuioCursor.sessionID);
			//trace("PERSON_REMOVED::",person);
			dispatchEvent(new PeopleEvent(PeopleEvent.PERSON_REMOVED,person));
		}
		
		public function updateTuioCursor(tuioCursor:TuioCursor):void
		{
			var person:Person = (peopleMap.get(tuioCursor.sessionID) as Person);
			person.moveTo(tuioCursor.x*FLOOR_WIDTH,tuioCursor.y*FLOOR_HEIGHT);
			//trace("PERSON_MOVED",person);
			dispatchEvent(new PeopleEvent(PeopleEvent.PERSON_MOVED, person));
		}
		
		
		public function newFrame(id:uint):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function addTuioObject(tuioObject:TuioObject):void
		{
			// TODO Auto Generated method stub
			
		}
		public function addTuioBlob(tuioBlob:TuioBlob):void
		{
			// TODO Auto Generated method stub
			
		}
		public function removeTuioBlob(tuioBlob:TuioBlob):void
		{
			// TODO Auto Generated method stub
			
		}
		

		
		public function removeTuioObject(tuioObject:TuioObject):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function updateTuioBlob(tuioBlob:TuioBlob):void
		{
			// TODO Auto Generated method stub
			
		}
		

		
		public function updateTuioObject(tuioObject:TuioObject):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}