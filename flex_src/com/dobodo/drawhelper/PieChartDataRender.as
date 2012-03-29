package com.dobodo.drawhelper
{
	import mx.charts.HitData;
	import mx.charts.series.items.PieSeriesItem;
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	
	public class PieChartDataRender extends UIComponent implements IDataRenderer,IFlexDisplayObject
	{
//		private var targetData:Object;
		private var tracking:Boolean = false;
			private var mouseState:String = "";
		public function PieChartDataRender()
		{

		}
	
		 public function set data(value:Object):void
		{
			super.data = value;
			var hd:HitData = value as HitData;
			var item:PieSeriesItem = hd.chartItem as PieSeriesItem;
			item.element.labelContainer.x = 200;
			item.element.labelContainer.y = 200;
		}
	}
}