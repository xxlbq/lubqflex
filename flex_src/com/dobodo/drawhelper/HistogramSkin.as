package com.dobodo.drawhelper
{
	import flash.display.Graphics;
	import flash.display.GradientType;
	import mx.charts.series.items.ColumnSeriesItem;
	import mx.core.IDataRenderer;
	import mx.skins.ProgrammaticSkin;

	public class HistogramSkin extends ProgrammaticSkin implements IDataRenderer
	{
		private var colors:Array = [0x60cb00,0x6a7a88,0x3698ff,0x66a800,0xff6600,0x655fc8,0xd2691e];
		private var _chartItem:ColumnSeriesItem;
		
		public function HistogramSkin(){}
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
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(colors[(_chartItem == null)?0:_chartItem.index]);
			g.drawRect(0,unscaledWidth * 0.125,unscaledWidth,unscaledHeight);
			g.lineStyle(1,0xffffff,0.25);
			g.beginFill(colors[(_chartItem == null)?0:_chartItem.index]);
			g.drawEllipse(0,0,unscaledWidth,unscaledWidth * 0.25);
			g.endFill();
		}
		
	}
}