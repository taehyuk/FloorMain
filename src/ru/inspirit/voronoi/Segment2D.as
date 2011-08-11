package ru.inspirit.voronoi 
{
	import flash.display.Graphics;
	
	/**
	* ...
	* @author Eugene Zatepyakin
	*/
	public class Segment2D 
	{
		
		public var start:Point2D;
		public var end:Point2D;
		public var points:Array;
		public var bisector:Segment2D = null;
		
		public function Segment2D(startx:Number = 0, starty:Number = 0, endx:Number = 0, endy:Number = 0, id:int = -1) 
		{
			start = new Point2D(startx, starty);
			end = new Point2D(endx, endy);
			start.onBorder = id;
			end.onBorder = id;
			points = new Array(start, end);
		}
		
		public static function FromPoints(start:Point2D, end:Point2D, id:int = -1):Segment2D
		{
			return new Segment2D(start.x, start.y, end.x, end.y, id);
		}
		
		public static function FromSegment(segment:Segment2D):Segment2D
		{
			return new Segment2D(segment.start.x, segment.start.y, segment.end.x, segment.end.y);
		}
		
		public function add(point:Point2D):void
		{
			var unique:Boolean = true;
			var i:int = points.length;
			while (--i >= 0) {
				if (point.equals(points[i] as Point2D, 0.1)){
					unique = false;
					break;
				}
			}
			if (unique) points.push(point);
		}
		
		public function get(i:int):Point2D
		{
			return points[i] as Point2D;
		}
		
		public static function segmentIntersectionWithSegment(segment1:Segment2D, segment2:Segment2D):Point2D 
		{
			var result:Point2D = null;
			var denominator:Number = (segment2.end.y-segment2.start.y)*(segment1.end.x-segment1.start.x)-(segment2.end.x-segment2.start.x)*(segment1.end.y-segment1.start.y);
			if (denominator == 0) return result;
			var ua:Number = ((segment2.end.x-segment2.start.x)*(segment1.start.y-segment2.start.y)-(segment2.end.y-segment2.start.y)*(segment1.start.x-segment2.start.x))/denominator;
			var ub:Number = ((segment1.end.x-segment1.start.x)*(segment1.start.y-segment2.start.y)-(segment1.end.y-segment1.start.y)*(segment1.start.x-segment2.start.x))/denominator;
			if((ua>1)||(ua<0)||(ub>1)||(ub<0)) return result;
			result = new Point2D(segment1.start.x+ua*(segment1.end.x-segment1.start.x), segment1.start.y+ua*(segment1.end.y-segment1.start.y));
			return result;
		}

		public static function segmentIntersectionWithLine(segment1:Segment2D, segment2:Segment2D):Point2D
		{
			var result:Point2D = null;
			var denominator:Number = (segment2.end.y-segment2.start.y)*(segment1.end.x-segment1.start.x)-(segment2.end.x-segment2.start.x)*(segment1.end.y-segment1.start.y);
			if (denominator == 0) return result;
			var ua:Number = ((segment2.end.x-segment2.start.x)*(segment1.start.y-segment2.start.y)-(segment2.end.y-segment2.start.y)*(segment1.start.x-segment2.start.x))/denominator;
			if((ua>1)||(ua<0)) return result;
			result = new Point2D(segment1.start.x+ua*(segment1.end.x-segment1.start.x),segment1.start.y+ua*(segment1.end.y-segment1.start.y));
			return result;
		}
		
		public function draw(g:Graphics):void
		{
			g.moveTo(start.x, start.y);
			g.lineTo(end.x, end.y);
		}
		
	}
	
}