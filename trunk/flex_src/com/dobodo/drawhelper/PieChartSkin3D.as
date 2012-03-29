package com.dobodo.drawhelper
{

import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.filters.*;
import flash.geom.Point;

import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.Series;
import mx.charts.series.PieSeries;
import mx.charts.series.items.PieSeriesItem;
import mx.charts.series.renderData.PieSeriesRenderData;
import mx.core.IDataRenderer;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;


/**
 * 
 * @author xxlbq
 */
public class PieChartSkin3D extends UIComponent implements IDataRenderer
{

	private static const SHADOW_INSET:Number = 8;
	public var color:Number;
	public var overColor:Number = 0xFF8822;
	public var downColor:Number = 0xFF8822;
	private var tracking:Boolean = false;
	private var mouseState:String = "";
    private var alp:Number=1;
//    private var alp:Number=0.60;
    private var mostate:Boolean=false;
    
    
   		var tempalpha:Number = 1;
   		var pi:Number=Math.PI;
		var angle90:Number= pi/2;
		var angle180:Number=pi;
		var angle270:Number=pi/2*3;

	private var _wedge:PieSeriesItem;
	private var _series:PieSeries;

 
	public function PieChartSkin3D() 
	{
		super();
		this.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
		this.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
		
	}

	
		
	private function rollOverHandler(e:MouseEvent):void
	{
		if(tracking)
			mouseState = "down";
		else
			mouseState = "over";
		//	alp=0.9;
		invalidateDisplayList();
	}

	private function rollOutHandler(e:MouseEvent):void
	{
		if(tracking)
			mouseState = "over";
		else
			mouseState = "";
			//alp=0.9;
		invalidateDisplayList();
	}
	private function downHandler(e:MouseEvent):void
	{
		systemManager.addEventListener(MouseEvent.MOUSE_UP,upHandler,true);
		mouseState = "down";
		tracking= true;
		//alp=0.9;
		invalidateDisplayList();
	}

	private function upHandler(e:MouseEvent):void
	{
		systemManager.removeEventListener(MouseEvent.MOUSE_UP,upHandler,true);
		if(mouseState == "down")
			mouseState = "up";
		else
			mouseState = "";
			//alp=0.9;
		invalidateDisplayList();
		tracking= false;
	}

	public function get data():Object
	{
		return _wedge;
	}

	public function set data(value:Object):void
	{
		_wedge = PieSeriesItem(value);
		_series = value.element as PieSeries;
		invalidateDisplayList();
	}
	
	
//	override protected function measure():void {
//		super.measure();
//		
//	}
	
	override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void{
		
		
		
		super.updateDisplayList(unscaledWidth, unscaledHeight);

//	super.updateDisplayList(2 * _a, 2 * _b);


		updateDisplay(alp);
		updateLabelData();
		
	}
	public function updateDisplay(alp:Number):void
	{
		
       	var stroke:IStroke = getStyle("stroke");		
		var radialStroke:IStroke = getStyle("radialStroke");	
		
		var outerRadius:Number = _wedge.outerRadius;
		var innerRadius:Number = _wedge.innerRadius;
		
		var origin:Point = _wedge.origin;
		var angle:Number = _wedge.angle;
		
		var startAngle:Number = _wedge.startAngle;
		var endAngle:Number=startAngle+angle;
//		
		var _a:Number=outerRadius;              //长轴 
		var _b:Number=outerRadius;          //短轴
//		var _b:Number=4*outerRadius/8;          //短轴
//		var _b:Number=5*outerRadius/8;          //短轴
		
		
		var h:Number=outerRadius/3;             //厚度	
//		if(h>20){
//			h=20;
//		}
//		h=40;


		var step:Number=0;
		
//		if(_wedge.index > 1){
//			return ;
//		}
		
		
		if (!_wedge)
			return;

		var fillColor:Number;
//		var fillColors:Array=[0xB2B6F5,0xE59490];

		if(!isNaN(color))	
			fillColor = color;
		else
		{
			f = _wedge.fill;
			if(f is SolidColor)
			{
					fillColor = SolidColor(f).color;
			}
		}
		
//		recolor=fillColor;
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

		var drakColor:uint=getDarkColor(fillColor);//深色
		var g:Graphics = graphics;
		var f:IFill;
		 g.clear();	
       	   
		if (stroke && !isNaN(stroke.weight))
			outerRadius -= Math.max(stroke.weight/2,SHADOW_INSET);
		else
			outerRadius -= SHADOW_INSET;
						
		outerRadius = Math.max(outerRadius, innerRadius);   //外半径
		
//		var rc:Rectangle = new Rectangle(origin.x - _a,
//										 origin.y - _b,
//										 2 * _a, 2 * _b);
		
			
		var startBPt:Point = new Point(
			origin.x + Math.cos(startAngle) * _a,
			origin.y+h - Math.sin(startAngle) * _b);                    //下面的开始点
		var endBPt:Point = new Point(
			origin.x + Math.cos(startAngle + angle) * _a,
			origin.y+h - Math.sin(startAngle + angle) * _b);            //下面的终点
			
		var startTPt:Point = new Point(                                     //上面的开始点
			origin.x + Math.cos(startAngle) * _a,
			origin.y - Math.sin(startAngle) * _b);                                     
		var endTPt:Point = new Point(                                      //上面的终点                                
			origin.x + Math.cos(startAngle + angle) * _a,
			origin.y - Math.sin(startAngle + angle) * _b);
	
		
		trace ("startAngle:"+ startAngle+",angle:"+angle + ",endangle:"+endAngle);
			
		if(!isNaN(fillColor)){
			g.beginFill(fillColor,tempalpha);	
		}
		else{
			
//			f.begin(g,rc);
		}
		
		
		if(startAngle < angle180 && endAngle > angle180){
			
			var endBPt_split1 :Point = new Point();
			endBPt_split1.x = origin.x - _a;
			endBPt_split1.y = origin.y+h;
			
			var endTPt_split1 :Point = new Point();
			endTPt_split1.x = origin.x - _a;
			endTPt_split1.y = origin.y;
			
			
			drawPie(g,fillColor,startBPt,endBPt_split1,startTPt,endTPt_split1,radialStroke
				,origin,outerRadius,innerRadius,h
				,_a,_b,startAngle,angle180,angle180-startAngle
				,drakColor,true);
			
			
			
			
			var startBPt_split1 :Point = new Point();
			startBPt_split1.x = origin.x - _a;
			startBPt_split1.y = origin.y+h;
			
			var startTPt_split1 :Point = new Point();
			startTPt_split1.x = origin.x - _a;
			startTPt_split1.y = origin.y;
				
				
			drawPie(g,fillColor,startBPt_split1,endBPt,startTPt_split1,endTPt,radialStroke
				,origin,outerRadius,innerRadius,h
				,_a,_b,angle180,endAngle,endAngle-angle180
				,drakColor,true);	
				
				
				
		}
		else{
		
			drawPie(g,fillColor,startBPt,endBPt,startTPt,endTPt,radialStroke
				,origin,outerRadius,innerRadius,h
				,_a,_b,startAngle,endAngle,angle
				,drakColor,false);
		}


		trace ("pie serise : labelx="+_wedge.element.labelContainer.width + ",labely="+_wedge.element.labelContainer.height);
		
		
		
	}

	private function drawPie(g:Graphics,fillColor:Number,startBPt:Point,endBPt:Point,startTPt:Point,endTPt:Point,radialStroke:IStroke
			,origin:Point,outerRadius:Number,innerRadius:Number,h:Number
			,_a:Number,_b:Number,startAngle:Number,endAngle:Number,angle:Number
			,drakColor:uint,hideLine:Boolean):void{
		

						
		//画底部
		g.beginFill(fillColor,0);	
		g.moveTo(endBPt.x, endBPt.y);
		GraphicsUtilities.setLineStyle(g, radialStroke);

		if (innerRadius == 0)
		{
			
			g.lineTo(origin.x, origin.y+h);
			g.lineTo(startBPt.x, startBPt.y);
		}
//		GraphicsUtilities.setLineStyle(g,  getStyle("stroke"));
		GraphicsUtilities.drawArc(g, origin.x, origin.y+h,startAngle, angle, _a, _b, true);
		g.endFill();
			trace ("startAngle:"+ startAngle+",angle:"+angle + ",endangle:"+endAngle 
			+ ",startBPt.x:"+startBPt.x+",startBPt.y:"+startBPt.y+",startTPt.x:"+startTPt.x + ",startTPt.y:"+startTPt.y
			+ ",endBPt.x:"+endBPt.x + ",endBPt.y:"+endBPt.y + ",endTPt.x:"+endTPt.x + ",endTPt.y:"+endTPt.y
			+ ",long:"+_a+",short:"+_b);
		
			//画内弧
			if((startAngle<=pi/2&&startAngle>=0)||(startAngle>=3*pi/2&&startAngle<=2*pi)){
			g.lineStyle(0,drakColor,0)
			g.beginFill(drakColor,0);
			g.moveTo(startBPt.x, startBPt.y);
			g.lineTo(startTPt.x,startTPt.y);
			
//			if(hideLine){
//				g.lineStyle(0,drakColor,1);
				g.lineTo(origin.x,origin.y);
				g.lineStyle(0,drakColor,0)
//			}else{
				g.lineTo(origin.x,origin.y);
//			}

			
			g.lineTo(origin.x,origin.y+h);
			g.lineTo(startBPt.x, startBPt.y);
			g.endFill();
			}
			
			
			//画外弧
			if((pi/2<=startAngle&&startAngle<=3*pi/2)){
				
			g.lineStyle(0,drakColor,1)
			g.beginFill(drakColor,1);
			g.moveTo(endBPt.x,endBPt.y);
			g.lineTo(endTPt.x,endTPt.y);
			
//			if(hideLine){
//				g.lineStyle(0,drakColor,1);
				g.lineTo(origin.x,origin.y);
//				g.lineStyle(0,drakColor,1)
//			}else{
				g.lineTo(origin.x,origin.y);
//			}
			
			
			g.lineTo(origin.x,origin.y+h);
			g.lineTo(endBPt.x,endBPt.y);
			g.endFill();
			
			}
//		
			//画圆弧侧面
			if(((startAngle <=2*pi && startAngle>=pi)||( endAngle> pi))){
				
				g.beginFill(drakColor,1);
			    g.moveTo(startTPt.x,startTPt.y);
				GraphicsUtilities.drawArc(g, origin.x, origin.y,startAngle, angle,_a, _b, true);
				g.lineTo(endTPt.x,endTPt.y);
				g.lineTo(endBPt.x,endBPt.y);
				 GraphicsUtilities.drawArc(g, origin.x, origin.y+h,startAngle, angle,_a, _b, true);
				 g.lineTo(startBPt.x,startBPt.y);
				 g.endFill();
			}else{
//				trace("pieName:"+_wedge.itemRenderer.name + ",pieValue:"+_wedge.value
//				+ ",startAngle:"+startAngle + ",endAngle:"+endAngle);
			}
			
			//画上面的
	
			g.beginFill(fillColor,1);
			g.moveTo(endTPt.x,endTPt.y);
			
			if(hideLine){
				g.lineStyle(0,fillColor,1);
				g.lineTo(origin.x,origin.y);
				g.lineTo(startTPt.x,startTPt.y);
				
			}else{
				
				g.lineTo(origin.x,origin.y);
				g.lineTo(startTPt.x,startTPt.y);
			}
			
			GraphicsUtilities.drawArc(g, origin.x, origin.y,startAngle, angle,_a, _b, true);
			
			g.endFill();	
		

	
	}
	
	private function updateLabelData():void {
		var superSeries : Series = _series as Series ;
		var pRenderDate : PieSeriesRenderData = superSeries.transitionRenderData as PieSeriesRenderData ;
		trace ("=======");
	}
	
	private function getDarkColor(color:uint):uint {
	   var r:uint=color >> 16 & 0xFF / 1.5;
	   var g:uint=color >> 8 & 0xFF / 1.2;
	   var b:uint=color & 0xFF /1.5;
	   return r << 16 | g << 8 | b;
	}
	
	}
}