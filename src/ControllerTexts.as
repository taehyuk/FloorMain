package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class ControllerTexts extends Sprite
	{
		private var effect:ControllerEffects;
		private var texts:String;
		private var textdisps:Vector.<TextField> = new Vector.<TextField>;
		public function ControllerTexts(effect:ControllerEffects)
		{
			this.effect = effect
			this.texts = effect.texts;
			Floor.getInstance().addChild(this);
			super();
			this.visible = false;
			initTexts();
		}					
		
		private function initTexts():void
		{
			for(var i:int = 0 ; i < 10; i++){
				var tf:TextField = new TextField();
				
				this.addChild(tf);
				
				
				textdisps.push(tf);
				tf.text = texts;
				tf.textColor = 0x222222;
				tf.x = effect.controlArea[0] + Math.random() * (effect.controlArea[1] - effect.controlArea[0]);
				tf.y = Math.random()* Floor.HEIGHT;
			}
		}
		
		public function add():void{
			this.visible = true;
		}
		public function remove():void{
			this.visible = false;
		}
	}
}