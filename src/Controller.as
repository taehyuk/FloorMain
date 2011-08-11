package
{
	import com.greensock.TweenLite;
	
	import data.FloorCalculator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Controller extends Sprite
	{
		private var owner:Person;
		public var id:uint;
		public var initialX:Number;
		public var initialY:Number;
		public var controlArea:Array;
		
		public var currentDepth:int;
		public var currentLocalLane:int;
		public var previousDepth:int;
		public var previousLocalLane:int;
		
		public var effect:ControllerEffects;
		
		public function Controller(id:uint, initialX:Number, initialY:Number)
		{
			this.id = id;
			this.x = this.initialX = initialX;
			this.y = this.initialY = initialY;
			this.controlArea = FloorCalculator.getLaneInterval(id);
			this.graphics.lineStyle(4,0x999999);
			this.graphics.drawCircle(0,0,20);
			Floor.getInstance().addChild(this);
			
			effect = new ControllerEffects(this);
		}
		


		public function moveTo(X:Number, Y:Number):void {
			TweenLite.to(this,0.1,{x:X, y:Y});
		}
		
		public override function set x(value:Number):void {
			super.x = value;
//			trace("[EVENT]","Controller.Moved");
			getCurrentLocalLane();
			dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_MOVED,this));
		}
		
		public override function set y(value:Number):void {
			super.y = value;
//			trace("[EVENT]","Controller.Moved");
			getCurrentDepth();
			dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_MOVED,this));
		}
		
		public function reset():void {
			//moveTo(initialX,initialY);
			owner = null;
			dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_RELEASED, this));
			TweenLite.to(this,0.2,{x:initialX, y:initialY});
		}
		
		private function getCurrentDepth():void{
			var curDepth:int = (FloorCalculator.depthCount - 1) - FloorCalculator.getLocation(this.x, this.y)[1];
			if(curDepth != currentDepth){
				this.previousDepth = this.currentDepth;
				this.currentDepth = curDepth;
				this.dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_DEPTH_CHANGED,this));
			}
		}
		private function getCurrentLocalLane():void{
			var curLane:int = FloorCalculator.getLocalLocation(this.x, this.y, initialX, initialY)[0];
			if(curLane != currentLocalLane){
				this.previousLocalLane = this.currentLocalLane;
				this.currentLocalLane = curLane;
				this.dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_LANE_CHANGED,this));
			}
		}
		public function get Owner():Person
		{
			return owner;
		}
		
		public function set Owner(value:Person):void
		{
			if(value != null){
				dispatchEvent(new ControllerEvent(ControllerEvent.CONTROLLER_INITIALIZED, this));
			}
			owner = value;
		}
		
		public override function toString():String {
			return "[Controller] {owner:"+owner+" initialX:"+initialX+" initialY:"+initialY+" x:"+x+" y:"+y+"}";
		}
	}
}