package
{
	import flash.display.Sprite;
	
	public class Person extends Sprite
	{
		public var _id:uint;
		public var _X:Number;
		public var _Y:Number;
		
		public function Person(id:uint, initialX:Number, initialY:Number)
		{
			_id = id;
			x = initialX;
			y = initialY;
			
			this.graphics.lineStyle(1,0x999999);
			this.graphics.beginFill(0xaaaaaa);
			this.graphics.drawCircle(0,0,10);
			
			Floor.getInstance().addChild(this);
			//trace(this);
		}

		public function moveTo(X:Number, Y:Number):void
		{
			x = X;
			y = Y;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public override function toString():String {
			return "[Person] {id:"+_id+" x:"+x+" y:"+y+"}";
		}
	}
}