package ru.inspirit.voronoi 
{
	
	/**
	* ...
	* @author Eugene Zatepyakin
	*/
	public class SegmentPoint2D extends Point2D
	{
		
		public var belongsToSegment:Array;
		
		public function SegmentPoint2D(x:Number = 0, y:Number = 0, id:Number = -1) 
		{
			super(x, y, id);
			belongsToSegment = new Array();
		}
		
		public static function FromPoint(p:Point2D):SegmentPoint2D
		{
			return new SegmentPoint2D(p.x, p.y, p.onBorder);
		}
		
		public function add(segment:Segment2D):void
		{
			belongsToSegment.push(segment);
		}
		
		public function convertToPoint2D():Point2D
		{
			return new Point2D(x, y, onBorder);
		}
		
	}
	
}