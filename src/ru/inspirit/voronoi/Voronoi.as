package ru.inspirit.voronoi 
{
	import flash.utils.getTimer;
	
	import ru.inspirit.utils.Random;
	
	/**
	 * ...
	 * @author Eugene Zatepyakin
	 */
	public class Voronoi 
	{
		
		public var NUMPOINTS:int;
		public var order:int;
		public var initialPoints:Array;
		public var initialSegments:Array;
		public var bisectors:Array;
		public var borders:Array;
		public var bisectorIntersections:Array;
		public var cells:Vector.<Cell>;
		public var fillColor:Array;
		public var strokeColor:uint;
		
		private var width:Number;
		private var height:Number;
		
		public function Voronoi(n:int, borders:Array, points:Array = null, order:int = 0, fc:Array = null, sc:uint = 0x000000) 
		{
			
//			width = Main._width;
//			height = Main._height;
//			
			width = 1024;
			height = 768;
			this.order = order;
			NUMPOINTS = n;
			initializeLists();
			this.borders = borders.concat();
			if (points != null) {
				initialPoints = points.concat();
			} else {
				generateInitialPoints();
			}
			generateInitialSegments();
			generateBisectors(); 
			generateBisectorIntersections();
			generateVoronoiSegments();
//			fillColor = fc;
			if(fc == null){
				fillColor = randomColor();
			}else
			{
				fillColor = fc;
			}
			strokeColor = sc;
		}
		
		private function randomColor():Array
		{
			var outVal:Array = new Array();
			for(var i:int = 0 ; i < NUMPOINTS ; i++){
				outVal.push(Math.random() * 0xFFFFFF);
			}
			return outVal;
		}
		
		public function initializeLists():void
		{
			initialPoints = new Array();
			initialSegments = new Array();
			bisectors = new Array();
			borders = new Array();
			bisectorIntersections = new Array();
			cells = new Vector.<Cell>;
		}
		
		public function extendToBorder(segment:Segment2D, borders:Array):Segment2D
		{
			var startPoint:Point2D = null ;
			var border:int = -1;
			var currentBorder:Segment2D = new Segment2D();
			var i:int = 0;
			while (i < borders.length && startPoint == null){
				currentBorder = borders[i] as Segment2D;
				startPoint = Segment2D.segmentIntersectionWithLine(currentBorder, segment);
				border++;
				i++;
			}
			if(startPoint != null) {
				startPoint.onBorder = border;
				currentBorder.add(startPoint);
			}
			
			var endPoint:Point2D = null;
			while (i < borders.length && endPoint == null) {
				currentBorder = borders[i] as Segment2D;
				endPoint = Segment2D.segmentIntersectionWithLine(currentBorder, segment);
				border++;
				i++;
			}
			if(endPoint != null){
				endPoint.onBorder = border;
				currentBorder.add(endPoint);
			}

			if((startPoint != null) && (endPoint != null)) return Segment2D.FromPoints(startPoint, endPoint);
			return Segment2D.FromSegment(segment);
		}
		
		public function generateInitialPoints():void
		{
			var minx:Number;
			var maxx:Number;
			var miny:Number;
			var maxy:Number;
			var currentBorder:Segment2D;
			
			minx = miny = 20000000;
			maxx = maxy = -1;
			
			var i:int = borders.length; 
			while(--i >= 0){
				currentBorder = borders[i] as Segment2D;
				minx = Math.min(minx,currentBorder.start.x);
				minx = Math.min(minx,currentBorder.end.x);
				miny = Math.min(miny,currentBorder.start.y);
				miny = Math.min(miny,currentBorder.end.y);    
				maxx = Math.max(maxx,currentBorder.start.x);
				maxx = Math.max(maxx,currentBorder.end.x);
				maxy = Math.max(maxy,currentBorder.start.y);
				maxy = Math.max(maxy, currentBorder.end.y); 
			}
			
			var trialPoint:SegmentPoint2D;
			for(i = 0; i < NUMPOINTS; i++) {
				trialPoint = new SegmentPoint2D(Random.float(minx,maxx), Random.float(miny,maxy));
				while(!inside(trialPoint)){
					trialPoint = new  SegmentPoint2D(Random.float(minx,maxx), Random.float(miny,maxy));
				}
				initialPoints[i] = trialPoint;
			}
		}
		
		public function inside(point:Point2D):Boolean
		{
			var result:Boolean = false;
			var testSegment:Segment2D = new Segment2D(point.x, point.y, width+1, point.y);
			var numIntersections:int = 0;
			var currentBorder:Segment2D;
			var i:int = borders.length;
			while(--i >= 0){
				currentBorder = borders[i] as Segment2D;
				if(Segment2D.segmentIntersectionWithSegment(testSegment, currentBorder) != null) numIntersections++;
			}
			if((numIntersections%2==1))  result = true;
			numIntersections = 0;
			testSegment = new Segment2D(point.x, point.y, point.x, height+1);
			i = 0;
			while(i < borders.length){
				currentBorder = borders[i] as Segment2D;
				if (Segment2D.segmentIntersectionWithSegment(testSegment, currentBorder) != null) numIntersections++;
				i++;
			}
			if((numIntersections%2==1))  result = true;
			return result;
		}
		
		public function generateInitialSegments():void
		{
			var pointi:SegmentPoint2D;
			var pointj:SegmentPoint2D;
			var segmentij:Segment2D;
			var i:int;
			var j:int;
			for(i = 0; i < NUMPOINTS; i++) {
				pointi = initialPoints[i] as SegmentPoint2D;
				for(j = i+1; j < NUMPOINTS; j++) {
					pointj = initialPoints[j] as SegmentPoint2D;
					segmentij = Segment2D.FromPoints(pointi.convertToPoint2D(), pointj.convertToPoint2D());
					initialSegments.push(segmentij);
					pointi.add(segmentij);
					pointj.add(segmentij);
				}
			}  
		}
		
		public function generateBisectors():void
		{
			var currentSegment:Segment2D;
			var midPoint:Point2D;
			var relPoint:Point2D;
			var startPoint:Point2D;
			var endPoint:Point2D;
			var bisector:Segment2D;
			var i:int = initialSegments.length;
			while (--i >= 0) {
				currentSegment = initialSegments[i] as Segment2D;
				midPoint = new Point2D((currentSegment.start.x+currentSegment.end.x)*.5, (currentSegment.start.y+currentSegment.end.y)*.5);
				startPoint = new Point2D(midPoint.x - (currentSegment.end.y - currentSegment.start.y), midPoint.y + (currentSegment.end.x - currentSegment.start.x));
				endPoint = new Point2D(midPoint.x + (currentSegment.end.y - currentSegment.start.y), midPoint.y - (currentSegment.end.x - currentSegment.start.x));
				bisector = Segment2D.FromSegment(extendToBorder(Segment2D.FromPoints(startPoint, endPoint), borders));
				bisectors[i] = bisector;
				currentSegment.bisector = bisector;
			}
		}
		
		public function generateBisectorIntersections():void
		{
			var bisectori:Segment2D;
			var bisectorj:Segment2D;
			var result:Point2D;
			var i:int;
			var j:int;
			for(i = 0; i < bisectors.length; i++) {
				bisectori = bisectors[i] as Segment2D;
				for(j = i+1; j < bisectors.length; j++) {
					bisectorj = bisectors[j] as Segment2D;
					result = Segment2D.segmentIntersectionWithSegment(bisectori, bisectorj);
					if (result != null) {
						bisectorIntersections.push(result);
						bisectori.points.push(result);
						bisectorj.points.push(result);
					}
				}
			}
		}
		
		public function generateVoronoiSegments():void
		{
			var periphery:Vector.<Point2D>;
			var currentCenterPoint:SegmentPoint2D;
			var currentSegment:Segment2D;
			var currentBisector:Segment2D;
			var currentSweepPoint:Point2D;
			var currentSweepRay:Segment2D;
			var currentSweepSegment:Segment2D;
			var currentSweepBisector:Segment2D;
			var sweepIntersection:Point2D;
			var peripheryPoint:Point2D;
			var intersect:Boolean;
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			i = initialPoints.length;
			while (--i >= 0) {
				currentCenterPoint = initialPoints[i] as SegmentPoint2D;
				periphery = new Vector.<Point2D>;
				j = currentCenterPoint.belongsToSegment.length;
				while(--j >= 0){
					currentSegment = currentCenterPoint.belongsToSegment[j] as Segment2D;
					currentBisector = currentSegment.bisector;
					k = currentBisector.points.length;
					while(--k >= 0){
						currentSweepPoint = currentBisector.points[k] as Point2D;
						currentSweepRay = Segment2D.FromPoints(currentCenterPoint, currentSweepPoint);
						l = currentCenterPoint.belongsToSegment.length;
						intersect = false;
						while(--l >= 0){
							currentSweepSegment = currentCenterPoint.belongsToSegment[l] as Segment2D;
							currentSweepBisector = currentSweepSegment.bisector;
							sweepIntersection = Segment2D.segmentIntersectionWithSegment(currentSweepRay, currentSweepBisector);
							if ((sweepIntersection!=null) && (!sweepIntersection.equals(currentSweepPoint, 0.01))){
						//	if ((sweepIntersection!=null) && (Point2D.dist(sweepIntersection,currentSweepPoint)>0.01)){
								intersect = true;
								break;
							}
						}
						if(!intersect){
							peripheryPoint = Point2D.FromPoint(currentSweepPoint);
							periphery.push(peripheryPoint);
						}
					}
				}
				
				j = borders.length;
				while(--j >= 0){
					currentSegment = borders[j] as Segment2D;
					k = currentSegment.points.length;
					while(--k >= 0){
						currentSweepPoint = currentSegment.points[k] as Point2D;
						currentSweepRay = Segment2D.FromPoints(currentCenterPoint,currentSweepPoint);
						l = currentCenterPoint.belongsToSegment.length;
						intersect = false;
						while(--l >= 0){
							currentSweepSegment = currentCenterPoint.belongsToSegment[l] as Segment2D;
							currentSweepBisector = currentSweepSegment.bisector;
							sweepIntersection = Segment2D.segmentIntersectionWithSegment(currentSweepRay, currentSweepBisector);
							if ((sweepIntersection!=null)&&(!sweepIntersection.equals(currentSweepPoint,0.01))){
						//	if ((sweepIntersection!=null) && (Point2D.dist(sweepIntersection,currentSweepPoint)>0.01)){
								intersect = true;
								break;
							}
						}
						if(!intersect){
							peripheryPoint = Point2D.FromPoint(currentSweepPoint);
							periphery.push(peripheryPoint);
						}
					}
				}
				
				var cell:Cell = new Cell(currentCenterPoint.convertToPoint2D());
				cell.periphery = periphery.concat();
				cell.update();
				cells.push(cell);
			}
		}
		
	}
	
}