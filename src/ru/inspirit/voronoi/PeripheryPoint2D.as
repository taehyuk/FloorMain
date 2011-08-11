package ru.inspirit.voronoi 
{
	
	/**
	* ...
	* @author Eugene Zatepyakin
	*/
	public class PeripheryPoint2D extends Point2D
	{
		
		public var angle:Number;
		public var centerPoint:Point2D;
		
		public function PeripheryPoint2D(point:Point2D, centerPoint:Point2D = null) 
		{
			super(point.x, point.y, point.onBorder);
			if (centerPoint != null) {
				this.centerPoint = Point2D.FromPoint(centerPoint);
				angle = Math.atan2(point.y - centerPoint.y, point.x - centerPoint.x);
			} else {
				this.centerPoint = Point2D.FromPoint(point);
				angle = (point as PeripheryPoint2D).angle;
			}
		}
		
		public function convertToPoint2D():Point2D
		{
			return new Point2D(x, y, onBorder);
		}
		
	}
	
}