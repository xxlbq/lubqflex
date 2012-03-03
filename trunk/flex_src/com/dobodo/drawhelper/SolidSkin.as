package com.dobodo.drawhelper
{
	import flash.geom.Point;
	
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.core.IDataRenderer;
	import mx.skins.ProgrammaticSkin;
	
	
	public class SolidSkin extends ProgrammaticSkin implements IDataRenderer
	{
		private var colors:Array = [0x60cb00,0x6a7a88,0x3698ff,0x66a800,0xff6600,0x655fc8,0xd2691e];
		private var _chartItem:ColumnSeriesItem;
		
		public function SolidSkin()
		{
			super();
		}
		public function get data():Object
		{
			return Object(_chartItem);
		}
		public function set data(value:Object):void
		{
			_chartItem = value as ColumnSeriesItem;
			invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{ 
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.clear();
			var points:Array = getPoints(unscaledWidth*0.65,unscaledHeight);
			drawFill(points[4],points[7],points[6],points[5]);
			drawFill(points[6],points[2],points[3],points[7]);
			drawFill(points[7],points[4],points[0],points[3]);
			this.graphics.endFill();
			
		}
		
		//根据长宽获取3D坐标信息
		function getPoints(w:Number,h:Number):Array
		{
			var points:Array = new Array(8);
			points[0] = new Point(0,h);
			points[1] = new Point(w,h);
			points[2] = new Point(w,0);
			points[3] = new Point(0,0);
			points[4] = new Point(0+w/2.0,h+w/2.0);
			points[5] = new Point(w+w/2.0,h+w/2.0);
			points[6] = new Point(w+w/2.0,0+w/2.0);
			points[7] = new Point(0+w/2.0,0+w/2.0);
			return points;
		}
		//根据传入的坐标信息，绘制线条及填充绘制区域
		function drawFill(...args):void
		{
			with(this.graphics)
			{
				lineStyle(0.5,0x7DBFC6,0.8);
				beginFill(colors[(_chartItem == null)?0:_chartItem.index],0.95);
				moveTo(args[0].x,args[0].y);
				for(var i=1;i<args.length;i++)
				{
					lineTo(args[i].x,args[i].y);
				}				
			}
		}
		
	}
}
