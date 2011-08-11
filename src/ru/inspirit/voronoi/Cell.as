package ru.inspirit.voronoi 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Eugene Zatepyakin
	 */
	public class Cell 
	{
		
		public var centerPoint:Point2D;
		public var periphery:Vector.<Point2D>;

		public function Cell(point:Point2D) 
		{
			centerPoint = Point2D.FromPoint(point);
			periphery = new Vector.<Point2D>;
		}
		
		public function update():void
		{
			clean();
			sort();
			removeCollinearPoints();
		}
		
		public function clean():void
		{
			var cleanedPeriphery:Vector.<Point2D> = new Vector.<Point2D>;
			var pointi:Point2D;
			var pointj:Point2D;
			var unique:Boolean;
			var i:int;
			var j:int;
			for(i = 0; i < periphery.length; i++) {
				pointi = periphery[i] as Point2D;
				unique = true;
				for(j = i+1; j < periphery.length; j++) {
					pointj = periphery[j] as Point2D;
					if (pointi.equals(pointj, 0.1)){
						unique = false;
						break;
					}
				}
				if(unique) cleanedPeriphery.push(pointi);
			}
			periphery = new Vector.<Point2D>;
			periphery = cleanedPeriphery.concat();
		}
		
		public function sort():void
		{
			var pointj:PeripheryPoint2D;
			var pointjj:PeripheryPoint2D;
			var temp:PeripheryPoint2D;
			var i:int;
			var j:int;
			
			i = periphery.length;
			while(--i >= 0) {
				for (j = 0; j < i; j++) {
					pointj = new PeripheryPoint2D((periphery[j] as Point2D), centerPoint);
					pointjj = new PeripheryPoint2D((periphery[j+1] as Point2D), centerPoint); 
					if (pointj.angle > pointjj.angle) {
						temp = new PeripheryPoint2D(pointj);
						periphery[j] = pointjj.convertToPoint2D();
						periphery[j+1] = temp.convertToPoint2D();
					}
				}
			}
		}
		
		public function removeCollinearPoints():void
		{
			var simplePeriphery:Vector.<Point2D> = new Vector.<Point2D>;
			var pointi:Point2D;
			var pointj:Point2D;
			var pointk:Point2D;
			var i:int;
			var j:int;
			var k:int;
			var cnt:int = 0;
			i = periphery.length;
			while(--i >= 0) {
				pointi = periphery[i] as Point2D;
				j = i-1;
				if(j < 0) j = periphery.length - 1;
				pointj = periphery[j] as Point2D;
				k = i+1;
				if(k == periphery.length) k=0;
				pointk = periphery[k] as Point2D;
				if (!Point2D.colinear(pointi, pointj, pointk, 0.01)){
					simplePeriphery[cnt++] = pointi;
				}
			}
			periphery = new Vector.<Point2D>;
			periphery = simplePeriphery.concat();
		}
		
	}
	
}