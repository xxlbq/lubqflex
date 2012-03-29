package com.dobodo.vo
{
	public class ChartVO
	{
		
			[Bindable]
			public var expenses:ArrayCollection ;
			
			[Bindable]
			public var lengValue:String ;
			
			[Bindable]
			public var Title:String ;
			
			[Bindable]
			public var xLabel:String;
			
			[Bindable]
			public var isShowAllTrip:Boolean =false;
			
		public function ChartVO()
		{
		}
		
		public function init(datas:ArrayCollection,leng:String,title:String,
			xtitle:String="",showAllTrip:Boolean=false):void
			
			{
				isShowAllTrip = showAllTrip;
				Title = title;
				xLabel= xtitle;
				if(expenses != null && expenses.length>0)
				{
					expenses.removeAll();
				}
				else
				{
					expenses = new ArrayCollection();
				}
				expenses = datas;
				lengValue = leng;
			}

	}
}