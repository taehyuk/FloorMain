package ru.inspirit.voronoi 
{
	import flash.display.Graphics;
	import flash.display.Shader;
	
	/**
	 * ...
	 * @author Eugene Zatepyakin
	 */
	public class VoronoiGraph 
	{
		
		public var polygons:Vector.<Polygon>;
		public var order:int;
		public var MAXORDER:int;
		public var fillColor:Array;
		public var strokeAlpha:Number;
		public var voronoi:Voronoi;
		public function VoronoiGraph(voronoi:Voronoi, MAXORDER:int) 
		{
			this.voronoi = voronoi;
			polygons = new Vector.<Polygon>;
			order = voronoi.order;
			fillColor = voronoi.fillColor;
			strokeAlpha = (MAXORDER-order+1)/MAXORDER;
			this.MAXORDER = MAXORDER;
			
			var currentPolygon:Polygon;
			var currentCell:Cell;
			var c:uint;
			var i:int = voronoi.cells.length;
			while(--i >= 0){
				currentCell = voronoi.cells[i] as Cell;
				c = voronoi.fillColor[i];
				currentPolygon = new Polygon(currentCell.periphery, strokeAlpha, strokeAlpha, c);
				polygons.push(currentPolygon);
			}
		}
		
		public function draw(g:Graphics):void
		{
			var i:int = polygons.length;
			while(--i >= 0){
				(polygons[i] as Polygon).draw(g);
			}       
		}
		public function gradientDraw(g:Graphics):void
		{
			var i:int = polygons.length;
			while(--i >= 0){
				var currentCenterPoint:Point2D = voronoi.initialPoints[i] as Point2D;
				(polygons[i] as Polygon).gradientDraw(g, currentCenterPoint);
			}       
		}
		public function strokeDraw(g:Graphics):void{
			var i:int = polygons.length;
			var invert:Boolean = true;
			while(--i >= 0){
				var currentCenterPoint:Point2D = voronoi.initialPoints[i] as Point2D;
				(polygons[i] as Polygon).strokeDraw(g, currentCenterPoint,invert);
				invert = !invert;
			}    
		}
		public function drawFill(g:Graphics):void
		{
			var i:int = polygons.length;
			while(--i >= 0){
				(polygons[i] as Polygon).drawFill(g);
			}      
		}

		public function drawStroke(g:Graphics):void
		{
			var i:int = polygons.length;
			while(--i >= 0){
				(polygons[i] as Polygon).drawStroke(g);
			} 
		}

		public function drawPoints(g:Graphics):void
		{
			var i:int = polygons.length;
			while(--i >= 0){
				(polygons[i] as Polygon).drawPoints(g);
			}      
		}
		
	}
	
}