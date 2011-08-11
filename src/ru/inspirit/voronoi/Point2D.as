package ru.inspirit.voronoi 
{
	import flash.display.Graphics;
	
	/**
	* ...
	* @author Eugene Zatepyakin
	*/
	public class Point2D 
	{
		
		public var x:Number;
		public var y:Number;
		
		public var onBorder:int;
		
		public function Point2D(x:Number = 0, y:Number = 0, id:int = -1) 
		{
			this.x = x;
			this.y = y;
			this.onBorder = id;
		}
		
		public static function FromPoint(p:Point2D):Point2D
		{
			return new Point2D(p.x, p.y, p.onBorder);
		}
		
		public function equals(point:Point2D, threshold:Number = 0):Boolean
		{
			return((point.x<x+threshold)&&(point.x>x-threshold)&&(point.y<y+threshold)&&(point.y>y-threshold));
		}
		
		public static function colinear(point1:Point2D, point2:Point2D, point3:Point2D, threshold:Number = 0):Boolean
		{
			if ((point1.x == point2.x) || (point2.x == point3.x)) return(point3.x == point1.x);
			
			var a1:Number = (point1.y - point2.y) / (point1.x - point2.x);
			var a2:Number = (point2.y - point3.y) / (point2.x - point3.x);
			var b1:Number = (point2.y * point1.x - point1.y * point2.x) / (point1.x - point2.x);
			var b2:Number = (point3.y * point2.x - point2.y * point3.x) / (point2.x - point3.x);
			var testPoint1:Point2D = new Point2D(a1, b1);
			var testPoint2:Point2D = new Point2D(a2, b2);
			return testPoint1.equals(testPoint2, threshold);
		}
		
		public static function dist(point1:Point2D, point2:Point2D):Number
		{
			var dx:Number = point1.x - point2.x;
			var dy:Number = point1.y - point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public function draw(g:Graphics):void
		{
			g.drawCircle(x, y, 2);
		}
		public function toArray():Array{
			return new Array(this.x,this.y);
		}
		
	}
	
}