package com.dobodo.drawhelper
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.charts.series.items.PieSeriesItem;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.SolidColor;

//import qs.utils.ColorUtils;
	public class tesetes extends UIComponent implements IDataRenderer
	{

		private static const SHADOW_INSET:Number=8;
		public var color:Number;
		public var overColor:Number=0xFF8822;
		public var downColor:Number=0xFF8822;
		private var tracking:Boolean=false;
		private var mouseState:String="";
		private var alp:Number=0.95;
		private var mostate:Boolean=false;

		public function tesetes()
		{
			super();
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);

		}

		private var _wedge:PieSeriesItem;


		private function rollOverHandler(e:MouseEvent):void
		{
			if (tracking)
				mouseState="down";
			else
				mouseState="over";
			//	alp=0.9;
			invalidateDisplayList();
		}

		private function rollOutHandler(e:MouseEvent):void
		{
			if (tracking)
				mouseState="over";
			else
				mouseState="";
			//alp=0.9;
			invalidateDisplayList();
		}

		private function downHandler(e:MouseEvent):void
		{
			systemManager.addEventListener(MouseEvent.MOUSE_UP, upHandler, true);
			mouseState="down";
			tracking=true;
			//alp=0.9;
			invalidateDisplayList();
		}

		private function upHandler(e:MouseEvent):void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, upHandler, true);
			if (mouseState == "down")
				mouseState="up";
			else
				mouseState="";
			//alp=0.9;
			invalidateDisplayList();
			tracking=false;
		}

		public function get data():Object
		{
			return _wedge;
		}

		public function set data(value:Object):void
		{
			_wedge=PieSeriesItem(value);
			invalidateDisplayList();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateDisplay(alp);
		}

		public function updateDisplay(alp:Number):void
		{

			var stroke:IStroke=getStyle("stroke");
			var radialStroke:IStroke=getStyle("radialStroke");
			var outerRadius:Number=_wedge.outerRadius;
			var innerRadius:Number=_wedge.innerRadius;
			var origin:Point=_wedge.origin;
			var angle:Number=_wedge.angle;
			var startAngle:Number=_wedge.startAngle;
			var endAngle:Number=startAngle + angle;
			var _a:Number=outerRadius; //长轴 
			var _b:Number=4 * outerRadius / 8; //短轴
			var h:Number=outerRadius / 2; //厚度	
			if (h > 20)
			{
				h=20;
			}
			var step:Number=0;
			var pi:Number=Math.PI;
			if (!_wedge)
				return;

			var fillColor:Number;
			var fillColors:Array=[0xB2B6F5, 0xE59490];
			if (!isNaN(color))
				fillColor=color;
			else
			{
				f=_wedge.fill;
				if (f is SolidColor)
				{
					fillColor=SolidColor(f).color;
				}
			}
////		recolor=fillColor;
//		var hsv:Object;
//	  hsv = ColorUtils.RGBToHSV(fillColor);
//					hsv.v = Math.min(1,hsv.v*1.3);
//					hsv.s = hsv.s *.8;
//					fillColor = ColorUtils.HSVToRGB(hsv);
//		switch(mouseState)
//		{
//			case "over":
//			if (isNaN(overColor))
//			{
//					hsv = ColorUtils.RGBToHSV(fillColor);
//					hsv.v = Math.min(1,hsv.v*1.3);
//					hsv.s = hsv.s *.8;
//			}
//			else
//			{
//				fillColor = overColor;
//			}
//				break;
//			case "down":
//			if(isNaN(downColor))				
//			{
//					hsv = ColorUtils.RGBToHSV(fillColor);
//					hsv.v = Math.min(1,hsv.v*1.3);
//					hsv.s = hsv.s *.8;
//					fillColor = ColorUtils.HSVToRGB(hsv);
//			}
//		else
//			{
//				fillColor = downColor;
//				}
//				break;
//			default:
//				break;
//		}

			var drakColor:uint=getDarkColor(fillColor); //深色
			var g:Graphics=graphics;
			var f:IFill;
			g.clear();

			if (stroke && !isNaN(stroke.weight))
				outerRadius-=Math.max(stroke.weight / 2, SHADOW_INSET);
			else
				outerRadius-=SHADOW_INSET;

			outerRadius=Math.max(outerRadius, innerRadius); //外半径

			var rc:Rectangle=new Rectangle(origin.x - _a, origin.y - _b, 2 * _a, 2 * _b);


			var startBPt:Point=new Point(origin.x + Math.cos(startAngle) * _a, origin.y + h - Math.sin(startAngle) * _b); //下面的开始点
			var endBPt:Point=new Point(origin.x + Math.cos(startAngle + angle) * _a, origin.y + h - Math.sin(startAngle + angle) * _b); //下面的终点

			var startTPt:Point=new Point( //上面的开始点
				origin.x + Math.cos(startAngle) * _a, origin.y - Math.sin(startAngle) * _b);
			var endTPt:Point=new Point( //上面的终点                                
				origin.x + Math.cos(startAngle + angle) * _a, origin.y - Math.sin(startAngle + angle) * _b);


			if (!isNaN(fillColor))
			{

				g.beginFill(fillColor, 0);
			}
			else
				f.begin(g, rc);
//画底部
			g.beginFill(fillColor, 0);
			g.moveTo(endBPt.x, endBPt.y);
			GraphicsUtilities.setLineStyle(g, radialStroke);

			if (innerRadius == 0)
			{
				g.lineTo(origin.x, origin.y + h);
				g.lineTo(startBPt.x, startBPt.y);
			}
			//GraphicsUtilities.setLineStyle(g, stroke);
			GraphicsUtilities.drawArc(g, origin.x, origin.y + h, startAngle, angle, _a, _b, true);
			g.endFill();
			//画内弧
			if ((startAngle <= pi / 2 && startAngle >= 0) || (startAngle >= 3 * pi / 2 && startAngle <= 2 * pi))
			{
				//g.lineStyle(0,drakColor,1)
				g.beginFill(drakColor, 0);
				g.moveTo(startBPt.x, startBPt.y);
				g.lineTo(startTPt.x, startTPt.y);
				g.lineTo(origin.x, origin.y);
				g.lineTo(origin.x, origin.y + h);
				g.lineTo(startBPt.x, startBPt.y);
				g.endFill();
			}
			//画外弧
			if ((pi / 2 <= startAngle && startAngle <= 3 * pi / 2))
			{

				//g.lineStyle(0,drakColor,1)
				g.beginFill(drakColor, 1);
				g.moveTo(endBPt.x, endBPt.y);
				g.lineTo(endTPt.x, endTPt.y);
				g.lineTo(origin.x, origin.y);
				g.lineTo(origin.x, origin.y + h);
				g.lineTo(endBPt.x, endBPt.y);
				g.endFill();

			}

			//画圆弧侧面
			if (((startAngle <= 2 * pi && startAngle >= pi) || (endAngle > pi)))
			{
				g.beginFill(drakColor, alp);
				g.moveTo(startTPt.x, startTPt.y);
				GraphicsUtilities.drawArc(g, origin.x, origin.y, startAngle, angle, _a, _b, true);
				g.lineTo(endTPt.x, endTPt.y);
				g.lineTo(endBPt.x, endBPt.y);
				GraphicsUtilities.drawArc(g, origin.x, origin.y + h, startAngle, angle, _a, _b, true);
				g.lineTo(startBPt.x, startBPt.y);
				g.endFill();
			}

			//画上面的
			g.beginFill(fillColor, alp);
			g.moveTo(endTPt.x, endTPt.y);
			g.lineTo(origin.x, origin.y);
			g.lineTo(startTPt.x, startTPt.y);

			GraphicsUtilities.drawArc(g, origin.x, origin.y, startAngle, angle, _a, _b, true);
			g.endFill();

		}

		private function getDarkColor(color:uint):uint
		{
			var r:uint=color >> 16 & 0xFF / 1.5;
			var g:uint=color >> 8 & 0xFF / 1.2;
			var b:uint=color & 0xFF / 1.5;
			return r << 16 | g << 8 | b;
		}
	}
}
