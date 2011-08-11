package ru.inspirit.voronoi 
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Eugene Zatepyakin
	 */
	public class Polygon 
	{
		
		public var points:Vector.<Point2D>;
		public var strokeColor:uint = 0x000000;
		public var strokeAlpha:Number;
		public var fillColor:uint;
		public var strokeWeight:Number;
		
		public function Polygon(points:Vector.<Point2D> = null, strokeAlpha:Number = 1, strokeWeight:Number = 0, fillColor:uint = 0xDD0000) 
		{
			this.points = new Vector.<Point2D>;
			if (points != null) {
				this.points = points.concat();
			}
			this.strokeAlpha = strokeAlpha;
			this.fillColor = fillColor;
			this.strokeWeight = strokeWeight;
		}
		
		public function drawStroke(g:Graphics):void
		{
			var i:int = points.length;
			var endPoint:Point2D = points[i - 1] as Point2D;
			var currentPoint:Point2D;
			
			g.lineStyle(strokeWeight, strokeColor);
			g.moveTo(endPoint.x, endPoint.y);
			
			i--;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				g.lineTo(currentPoint.x, currentPoint.y);
			}
			g.lineTo(endPoint.x, endPoint.y);
		}
		
		public function drawFill(g:Graphics):void
		{
			var i:int = points.length;
			var endPoint:Point2D = points[i - 1] as Point2D;
			var currentPoint:Point2D;
			
			g.beginFill(fillColor);
			g.moveTo(endPoint.x, endPoint.y);
			
			i--;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				g.lineTo(currentPoint.x, currentPoint.y);
			}
			g.lineTo(endPoint.x, endPoint.y);
			g.endFill();
		}
		
		public function draw(g:Graphics):void
		{
			var i:int = points.length;
			var endPoint:Point2D = points[i - 1] as Point2D;
			var currentPoint:Point2D;
			
			g.lineStyle(strokeWeight, strokeColor, strokeAlpha);
			g.beginFill(fillColor);
			g.moveTo(endPoint.x, endPoint.y);
			
			i--;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				g.lineTo(currentPoint.x, currentPoint.y);
			}
			g.lineTo(endPoint.x, endPoint.y);
			g.endFill();
		}
		public function strokeDraw(g:Graphics, currentPoint:Point2D, invert:Boolean):void
		{
			var i:int;
			var cellPt:Point2D = currentPoint;
			
			var insideCol:uint;
			var outsideCol:uint;
			
			if(invert){
				insideCol = fillColor;
				outsideCol = 0x000000;
			}else{
				insideCol = 0x000000;
				outsideCol = fillColor;
			}

			i = points.length;

			var endPoint:Point2D = points[i - 1] as Point2D;
			var currentPoint:Point2D;

			g.beginFill(insideCol);
			g.moveTo(endPoint.x, endPoint.y);
			
			i--;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				g.lineTo(currentPoint.x, currentPoint.y);
			}
			g.lineTo(endPoint.x, endPoint.y);
			g.endFill();
			
			
			
			i = points.length
			
			var innerEndPoint:Point2D = points[i - 1] as Point2D;
			innerEndPoint = getOffsetPoint(endPoint, cellPt, 80);
			var innerCurrentPoint:Point2D;
			
			g.beginFill(outsideCol);
			g.moveTo(innerEndPoint.x, innerEndPoint.y);
			
			i--;
			while (--i >= 0) {
				innerCurrentPoint = getOffsetPoint(points[i], cellPt, 80);
				g.lineTo(innerCurrentPoint.x, innerCurrentPoint.y);
			}
			g.lineTo(innerEndPoint.x, innerEndPoint.y);
			g.endFill();
		}
		
		
		public function gradientDraw(g:Graphics, currentPoint:Point2D):void
		{
			var i:int;
			var j:int;
			var gradientCount:int = 5;
			
			var cellPt:Point2D = currentPoint;
			
			
			for ( j = gradientCount - 1 ; j >= 0 ; j--){
				i = this.points.length;
				var endPoint:Point2D = points[i - 1] as Point2D;
				var currentPoint:Point2D;
				var transformedColor:uint = getTransformedColor(fillColor, j , gradientCount);
				endPoint = getTransformedPoint(endPoint, cellPt, j, gradientCount);
				
				g.beginFill(transformedColor,1);
				g.moveTo(endPoint.x, endPoint.y);
				i--;
				while (--i >= 0) {
					currentPoint = getTransformedPoint(points[i], cellPt, j, gradientCount);
					g.lineTo(currentPoint.x, currentPoint.y);
				}
				g.lineTo(endPoint.x, endPoint.y);
				g.endFill();
			}
			
		}
		
		private function getTransformedColor(fillColor:uint,n:int, count:int):uint
		{
			var cenR:uint = 0xFF;
			var cenG:uint = 0xFF;
			var cenB:uint = 0xFF;
			
			var r:uint = (fillColor >> 16) & 0xFF;
			var g:uint = (fillColor >> 8) & 0xFF;
			var b:uint = (fillColor) & 0xFF;
			
			var stepFactor:Number = 1 - n / count;

			r = r + (cenR - r) * stepFactor;
			g = g + (cenG - g) * stepFactor;
			b = b + (cenB - b) * stepFactor;

			return (r << 16) | (g << 8) | b;
		}
		
		private function getTransformedPoint(tarPt:Point2D, cenPt:Point2D, n:int, count:int):Point2D
		{
			var stepFactor:Number = Math.pow((n+1) / count, 0.3);
			return new Point2D(cenPt.x + (tarPt.x - cenPt.x) * stepFactor , cenPt.y + (tarPt.y - cenPt.y) * stepFactor, tarPt.onBorder);
		}
		private function getOffsetPoint(tarPt:Point2D, cenPt:Point2D, val:Number):Point2D
		{
			var dist:Number = Math.sqrt(Math.pow((tarPt.x - cenPt.x),2) + Math.pow((tarPt.y - cenPt.y),2));
			var stepFactor:Number = 1 - val / dist;
			return new Point2D(cenPt.x + (tarPt.x - cenPt.x) * stepFactor , cenPt.y + (tarPt.y - cenPt.y) * stepFactor, tarPt.onBorder);
		}
		
		private function getBounds(points:Vector.<Point2D>):Vector.<Point>
		{
			var outVal:Vector.<Point> = new Vector.<Point>;
			var i:int = points.length;
			var currentPoint:Point2D;
			var maxX:Number = points[0].x;
			var maxY:Number = points[0].y;
			var minX:Number = points[0].x;
			var minY:Number = points[0].y;
			
			i--;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				if(currentPoint.x > maxX){
					maxX = currentPoint.x;
				}
				if(currentPoint.y > maxY){
					maxY = currentPoint.y;
				}
				if(currentPoint.x < minX){
					minX = currentPoint.x;
				}
				if(currentPoint.y < minY){
					minY = currentPoint.y;
				}
			}
			outVal.push(new Point(minX,minY),new Point(maxX,maxY));
			return outVal;
		}
		
		public function drawPoints(g:Graphics):void
		{
			var currentPoint:Point2D;
			g.beginFill(fillColor);
			g.lineStyle(1, strokeColor);
			var i:int = points.length;
			while (--i >= 0) {
				currentPoint = points[i] as Point2D;
				currentPoint.draw(g);
			}
			g.endFill();
		}
		
	}
	
}