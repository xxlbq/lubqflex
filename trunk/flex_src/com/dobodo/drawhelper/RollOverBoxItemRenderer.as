package com.dobodo.drawhelper
{

		import flash.display.Graphics;
		import flash.events.MouseEvent;
		import flash.geom.Matrix;
		import flash.geom.Rectangle;
		
		import mx.core.IDataRenderer;
		import mx.core.UIComponent;
		import mx.graphics.IStroke;
		
		import com.dobodo.qs.utils.ColorUtils;
		
		public class RollOverBoxItemRenderer extends UIComponent implements IDataRenderer
		{
		public function RollOverBoxItemRenderer ():void
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
		}
			
		private var _data:Object;
		public var color:Number=8888E0;
		public var overColor:Number=8888E0;
		public var downColor:Number=8888E0;
		private var tracking:Boolean = false;
		private var mouseState:String = "";
		
		
		private function rollOverHandler(e:MouseEvent):void
		{
			if(tracking)
				mouseState = "down";
			else
				mouseState = "over";
				
			invalidateDisplayList();
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			if(tracking)
				mouseState = "over";
			else
				mouseState = "";
			invalidateDisplayList();
		}
		private function downHandler(e:MouseEvent):void
		{
			systemManager.addEventListener(MouseEvent.MOUSE_UP,upHandler,true);
			mouseState = "down";
			tracking= true;
			invalidateDisplayList();
		}
		
		private function upHandler(e:MouseEvent):void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_UP,upHandler,true);
			if(mouseState == "down")
				mouseState = "over";
			else
				mouseState = "";	
			invalidateDisplayList();
			tracking= false;
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			if (_data == value)
				return;
			_data = value;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
					
			var fillColor:Number = color;
			var lighter:Number=Lighten(fillColor);
			var hsv:Object;
		
			switch(mouseState)
			{
				case "over":
					if (isNaN(overColor))
					{
						hsv = ColorUtils.RGBToHSV(fillColor);
						hsv.v = Math.min(1,hsv.v*1.3);
						hsv.s = hsv.s *.8;
						fillColor = ColorUtils.HSVToRGB(hsv);
						fillColor = overColor;
					}
					else
					{
						fillColor = overColor;
					}
					break;
				case "down":
					if(isNaN(downColor))
					{
						hsv = ColorUtils.RGBToHSV(fillColor);
						hsv.v = hsv.v*.8;
						hsv.s = hsv.s *.8;
						fillColor = ColorUtils.HSVToRGB(hsv);
						fillColor = downColor;
					}
					else
					{
						fillColor = downColor;
					}
					break;
				default:
					break;
			}
			var stroke:IStroke = getStyle("stroke");				
		 var w:Number = stroke ? stroke.weight / 2 : 0; 	
			var rc:Rectangle = new Rectangle(w, w, width - 2 * w, height - 2 * w);
			var g:Graphics = graphics;
		  if(rc.width>35){
		  	rc.width=35;
		  }
		 var aph:uint=1;//叠合柱子
		 var wi:Number=rc.width;
		 var he:Number=rc.height;
		 var xx:Number=rc.width/2;
		 var ox:Number=rc.left+xx;
		 var oy:Number=rc.top;
		 	var matrix:Matrix=new Matrix();
			g.clear();		
			g.moveTo(ox,oy);
			g.beginFill(fillColor);
			if (stroke)
		      stroke.apply(g);
		       var colors:Array=[lighter,fillColor];
				var alphas:Array=[aph,aph];
				var ratios:Array=[0,255];
				// 画柱体的上面部分
				matrix.createGradientBox(wi, xx, (270/180)*Math.PI, ox, oy);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
				graphics.moveTo(ox,oy); 
			    graphics.lineTo(ox+wi,oy);
			    graphics.lineTo(ox+wi-xx,oy+xx);
			    graphics.lineTo(ox-xx,oy+xx);
			    graphics.endFill();
		      // 画柱体的前面，
			 	colors = [lighter,fillColor];
				alphas = [1,1];
				ratios = [0,127];
				matrix.createGradientBox(wi, he, Math.PI/2, ox-xx, oy+xx);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
			    g.drawRect(ox-xx,oy+xx,wi,he);
			    g.endFill();
			   //画右侧面
			   colors = [fillColor,lighter];
//				alphas = [0.7,0.7];
				alphas = [1,1];
				ratios = [0,255];
			    matrix.createGradientBox(xx, he+xx, (270/180)*Math.PI, ox+wi-xx, oy+xx);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
			    g.moveTo(ox+wi-xx,oy+xx);
			    g.lineTo(ox+wi,oy);
			    g.lineTo(ox+wi,oy+he-xx);
			    g.lineTo(ox+wi-xx,oy+he+xx);
			    g.endFill();
			   /**
				 * 如果有需要画后面，左侧面的话，画法和画前面，右侧面一样，只不过起始点不一样而已，大家可以自己画
				**/
		}
		
		private function Lighten( col:Number ) : Number
		{
			var rgb:Number = col; //decimal value for a purple color
			var red:Number = (rgb & 16711680) >> 16; //extacts the red channel
			var green :Number= (rgb & 65280) >> 8; //extacts the green channel
			var blue :Number= rgb & 255; //extacts the blue channel
			var p:Number=2;
			red += red/p;
			if( red > 255 )
				red = 255;
				
			green += green/p;
			if( green > 255 )
				green = 255;
				
			blue += blue/p;
			if( blue > 255 )
				blue = 255;
				
			return red << 16 | green << 8 | blue;
		}
	}


}
