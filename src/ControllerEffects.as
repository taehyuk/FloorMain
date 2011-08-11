package
{
	import com.greensock.TweenLite;
	
	import data.FloorCalculator;
	
	import de.polygonal.core.fmt.Sprintf;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ControllerEffects extends Sprite
	{
		private static const INDICATE_CIRCLE_COUNT:int = 5;
		
		public var texts:String = 'sample';
		public var controlArea:Array;
		
		private var controller:Controller;
		private var indicateCircles:Vector.<Sprite> = new Vector.<Sprite>;
		private var controllerText:ControllerTexts;
		
		public function ControllerEffects(controller:Controller)
		{
			this.controller = controller;
			this.controlArea = controller.controlArea;
			this.controller.addChild(this);
			super();
			initIndicater();
		}
		
		private function initIndicater():void
		{
			var i:int = INDICATE_CIRCLE_COUNT;
			while(i>0){
				var circle:Sprite = new Sprite();
				this.addChild(circle);
				indicateCircles.push(circle);
				circle.scaleX = circle.scaleY = 0.1;
				i--;
			}
			controllerText = new ControllerTexts(this);
		}
		
/*
		public function initializedEffect():void{
			var g:Graphics = this.graphics;

			var i:int = INDICATE_CIRCLE_COUNT;
			while(i>0){
				g.lineStyle(1 + Math.random() * 3,Math.random()*0xFFFFFF);
				g.drawCircle(Math.random()*5,Math.random()*5,30 + Math.random()*30);
				g.endFill();
				i--;
			}
			//triangle
			
			g.lineStyle();			
			g.beginFill(0xff0000);
			g.moveTo(0,-20);
			g.lineTo(-10,-60);
			g.lineTo(10,-60);
			g.lineTo(0,-20);
			g.endFill();
			
			
			this.addEventListener(Event.ENTER_FRAME, frameEvent);
		}
	
*/		
		public function initializedEffect():void{
			
			for each (var circle:Sprite in indicateCircles){
				
				TweenLite.to(circle, 1, {scaleX:1,scaleY:1,alpha:1});
				var g:Graphics = circle.graphics;
				g.clear();
				g.lineStyle(1 + Math.random() * 3,Math.random()*0xFFFFFF);
				g.drawCircle(Math.random()*5,Math.random()*5,30 + Math.random()*30);
				g.endFill();
				
			}
			controllerText.add();

			/*
			//triangle
			
			g.lineStyle();			
			g.beginFill(0xff0000);
			g.moveTo(0,-20);
			g.lineTo(-10,-60);
			g.lineTo(10,-60);
			g.lineTo(0,-20);
			g.endFill();
			*/

			this.addEventListener(Event.ENTER_FRAME, frameEvent);
		}

		protected function frameEvent(e:Event):void
		{
			this.rotation += 5;			
		}
		public function reset():void{
			
			for each (var circle:Sprite in indicateCircles){

				TweenLite.to(circle, 1, {scaleX:0.1,scaleY:0.1,alpha:0});

			}
			controllerText.remove();
			this.removeEventListener(Event.ENTER_FRAME, frameEvent);
			

		}
	}
}