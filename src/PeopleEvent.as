package
{
	import flash.events.Event;
	
	import org.tuio.TuioContainer;
	
	public class PeopleEvent extends Event
	{		
		public static const PERSON_ADDED:String = "PERSON_ADDED";
		public static const PERSON_REMOVED:String = "PERSON_REMOVED";
		public static const PERSON_MOVED:String = "PERSON_MOVED";
		
		private var _person:Person;
		
		public function PeopleEvent(type:String, person:Person)
		{
			super(type, false, false);
			_person = person;
		}
		
		public function get person():Person {
			return _person;
		}
	}
}