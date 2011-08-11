package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import ru.inspirit.voronoi.Segment2D;
	import ru.inspirit.voronoi.SegmentPoint2D;
	import ru.inspirit.voronoi.Voronoi;
	import ru.inspirit.voronoi.VoronoiGraph;
	
	public class VoronoiDrawer extends Sprite
	{
		private static var allowInst:Boolean;
		private static var _instance:VoronoiDrawer;
		private static var fillcol:Array = new Array(0x2CC6FF, 0x03394D, 0x096486, 0x0A84B1);
		
		private var floor:Floor = Floor.getInstance();
		private var points:Vector.<Controller>;
		private var addedCol:Array;
		private var borders:Array;
		private var voronoi:Voronoi;
		private var voronoiGraph:VoronoiGraph;
		private var renderPoints:Array;
		private var voronoiSprite:Sprite;
		
		public function VoronoiDrawer()
		{
			if (!allowInst) {
				throw new Error("Error: Instantiation failed: Use sensorDataListener.getInstance() instead of new.");
			}
			else
			{
				voronoiSprite = new Sprite();
				floor.addChildAt(voronoiSprite,0);
				
				//draw Graph
				drawGraph();
			}

		}
		public static function init():VoronoiDrawer {
			if(_instance == null){
				allowInst = true;
				_instance = new VoronoiDrawer();
				allowInst = false;
			}
			return _instance;
		}
		
		public static function getInstance():VoronoiDrawer {
			if(_instance == null){
				throw new Error("Please initialize with method init(...) first!");
			}
			return _instance
		}
		
		private function drawGraph():void
		{		
			
			points = ControllerManager.getInstance().controllers;
			update();
			
		}
		
		public function update(e:Event = null):void
		{			

			renderPoints = new Array();
			addedCol = new Array();
			
			var cnt:int = points.length;
			var controller:Controller;
			for(var i:int = 0 ; i < cnt; i++){
				controller = points[i] as Controller;
				if(controller.Owner != null){
					renderPoints.push(new SegmentPoint2D(controller.x, controller.y));
					addedCol.push(fillcol[controller.id]);
				}
			}
			
			/*
			for each (var controller:Controller in points){
				if(controller.Owner != null){
					renderPoints.push(new SegmentPoint2D(controller.x, controller.y));
					addedCol.push(fillcol[controller.id]);
				}
			}
			*/
			addedCol.reverse();
			generateBorders();
			voronoi = new Voronoi(renderPoints.length, borders, renderPoints, 0, addedCol);
			voronoiGraph = new VoronoiGraph(voronoi, 0);
			renderGraph();
//			trace('pointlength : ' + points.length);
//			trace('renderPointsLength : ' + renderPoints.length);

		}
		
		private function renderGraph():void
		{
			var g:Graphics = voronoiSprite.graphics;
			g.clear();
			switch(renderPoints.length){
				case 0:
					renderGrapics_case_noPerson();
					break;
				
				case 1:
					renderGraphics_case_onePerson();
					break;
				
				default:
					voronoiGraph.strokeDraw(g);
//					voronoiGraph.gradientDraw(g);
//					voronoiGraph.draw(g);
//					voronoiGraph.drawFill(g);
					g.endFill();
					break;
			}
		}
		
		private function renderGraphics_case_onePerson():void
		{
		/*	var g:Graphics = this.graphics;
			g.beginFill(0xffffff);
			g.drawRect(0,0,Floor.WIDTH, Floor.HEIGHT);
			g.endFill();	*/		
		}
		
		private function renderGrapics_case_noPerson():void
		{
		/*	var g:Graphics = this.graphics;
			g.beginFill(addedCol[0]);
			g.drawRect(0,0,Floor.WIDTH, Floor.HEIGHT);
			g.endFill();*/			
		}
		
		private function generateBorders():void
		{
			borders = new Array();
			var borderPoints:Array = new Array();
			var border:Segment2D = new Segment2D();
			var wdth:Number = Floor.WIDTH;
			var hght:Number = Floor.HEIGHT;
			border = new Segment2D(0, 0, wdth, 0, 0);
			borders.push(border);
			border = new Segment2D(0, hght, 0, 0, 1);
			borders.push(border);
			border = new Segment2D(wdth, 0, wdth, hght, 2);
			borders.push(border);
			border = new Segment2D(wdth, hght, 0, hght, 3);
			borders.push(border);
			
		}
		
	}
}