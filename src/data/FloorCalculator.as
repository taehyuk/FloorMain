package data
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.media.Sound;
	
	public final class FloorCalculator
	{
		
		public static var controllerCount:uint = ControllerManager.CONTROLLER_COUNT;
		public static var depthCount:uint = ControllerManager.DEPTH_COUNT;
		public static var localLaneCount:uint = ControllerManager.LOCAL_LANE_COUNT;
		
		public var enterSound:Sound;
		public var clickSound:Sound;
		
//		public var divideMatrix:Array = new Array(4,5);
		
		
		
		public function FloorCalculator(){}
		
		public static function getInstance():FloorCalculator {
			if(_instance == null){
				_instance = new FloorCalculator();
			}
			return _instance
		}
		
		public static function getLocation(x:Number, y:Number):Array{
			var countX:Number = FloorCalculator.controllerCount;
			var countY:Number = FloorCalculator.depthCount;
			var i:int;
			var lane:Number;
			var depth:Number;
			for(i = 0 ; i < countX ; i ++){
				if(x > i * (Floor.WIDTH / countX) && x <= (i+1) * (Floor.WIDTH / countX)){
					lane = i;
					continue;
				}
			}
			for(i = 0 ; i < countY ; i ++){
				if(y > i * (Floor.HEIGHT / countY) && y <= (i+1) * (Floor.HEIGHT / countY)){
					depth = i;
					continue;
				}
			}
			return new Array(lane, depth);
		}
		
		public static function getLocalLocation(x:Number, y:Number, orgX:Number, orgY:Number):Array{
			var countX:Number = FloorCalculator.localLaneCount;
			var countY:Number = FloorCalculator.depthCount;
			var i:int;
			var lane:Number;
			var depth:Number;
			for(i = -countX ; i < countX ; i ++){
				if((x-orgX) > (i - 0.5) * (Floor.WIDTH / countX) && (x-orgX) <= (i+0.5) * (Floor.WIDTH / countX)){
					lane = i;
					continue;
				}
			}
			for(i = 0 ; i < countY ; i ++){
				if(y > i * (Floor.HEIGHT / countY) && y <= (i+1) * (Floor.HEIGHT / countY)){
					depth = i;
					continue;
				}
			}
			return new Array(lane, depth);
		}
		
		
		////////////수정 필요/////////////////
		public static function getLocalLanePosition(lane:int, x:Number, y:Number):Number{
			var countX:Number = FloorCalculator.localLaneCount;
			var intvX:Number = Floor.WIDTH / FloorCalculator.localLaneCount;
			var cenLocX:Number = FloorCalculator.getLaneArray()[lane];
			
			
			return cenLocX + intvX * Math.round((x - cenLocX) / intvX);
		}
		
		public static function getDepthPosition(depth:int):Number{
			var countY:Number = FloorCalculator.depthCount;
			return (Floor.HEIGHT / (countY*2)) * (2*(FloorCalculator.depthCount -1 - depth)+1);
				
		}
		
		public static function getDepthArray():Array{
			var outVal:Array = new Array();
			var countY:Number = FloorCalculator.depthCount;
			var i:int;
			
			for(i = 0 ; i < countY ; i++){
				outVal.push((Floor.HEIGHT / (countY*2)) * (2*i+1));
			}
			
			return outVal;
		}
		
		public static function getLaneArray():Array{
			var outVal:Array = new Array();
			var countX:Number = FloorCalculator.controllerCount;
			var i:int;
			
			for(i = 0 ; i < countX ; i++){
				outVal.push((Floor.WIDTH / (countX*2)) * (2*i+1));
			}
			
			return outVal;
		}
		
		public static function getLaneInterval(n:int):Array{
			var outVal:Array = new Array();
			var laneArray:Array = new Array();
			var countX:Number = FloorCalculator.controllerCount;
			var i:int;
			var intv:Number = Floor.WIDTH / countX;
			for(i = 0 ; i < countX ; i++){
				laneArray.push((Floor.WIDTH / (countX*2)) * (2*i+1));
			}
			
			return new Array(laneArray[n] - intv/2, laneArray[n] + intv/2);
		}
		
		protected static var _instance:FloorCalculator;
	}
}