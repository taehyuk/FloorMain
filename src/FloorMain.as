package
{
	import flash.display.Sprite;
	import flash.desktop.NativeApplication;
	import flash.events.Event;

	import org.tuio.TuioClient;
	import org.tuio.connectors.UDPConnector;
	
	[SWF (backgroundColor="#000000", width = "1024", height="480", frameRate="24")]
	
	public class FloorMain extends Sprite
	{
		import flash.display.Stage;
		
		private const DEST_IP:String = "0.0.0.0";
		private const DEST_PORT:int = 3334;
		
		
		// VARIABLES
		private var tuioClient:TuioClient;
		private var tuioConnector:UDPConnector;
		
		
		public function FloorMain()
		{
			
			//initialize Floor
			Floor.init();
			Floor.getInstance().x = 0;
			Floor.getInstance().y = 0;
			
			
			//initialize People and Controller
			
			People.init();
			ControllerManager.init();
			VoronoiDrawer.init();

			stage.addChild(Floor.getInstance());

			
			try
			{
				tuioConnector = new UDPConnector(DEST_IP, DEST_PORT,true);
				tuioClient = new TuioClient(tuioConnector);
			}
			catch (err:Error)
			{
				trace(err.message);
				NativeApplication.nativeApplication.exit();
			}
			
			tuioClient.addListener(People.getInstance());
			
			
			//EXITING EVENT
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onWindowClosing);

		}
		
		
		
		protected function onWindowClosing(event:Event):void
		{
			trace('closingEvent catch');
			try{
				tuioConnector.close();
			}catch(err:Error){
				trace("ERRORID="+err.errorID);
				trace("MESSAGE="+err.message);
			}			
		}
	}
}