package com.dobodo.drawhelper
{

		import flash.display.Graphics;
		import flash.events.MouseEvent;
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		
		import mx.charts.series.items.ColumnSeriesItem;
		import mx.core.IDataRenderer;
		import mx.core.UIComponent;
		import mx.graphics.IFill;
		import mx.graphics.IStroke;
		import mx.graphics.SolidColor;
		
		public class RollOverBoxItemRenderer extends UIComponent implements IDataRenderer
		{
		public function RollOverBoxItemRenderer ():void
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
		}
			
//		private var _data:Object;
		private var _wedge:ColumnSeriesItem;
		public var color:Number;
//		public var overColor:Number=8888E0;
//		public var downColor:Number=8888E0;
		private var tracking:Boolean = false;
		private var mouseState:String = "";
		
				private var slope:Number = 3.0 ;
				
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
			return _wedge;
		}
		public function set data(value:Object):void
		{
			if (_wedge == value)
				return;
			_wedge = ColumnSeriesItem(value);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			trace("unscaledWidth="+unscaledWidth + ",unscaledHeight"+unscaledHeight);		
			
			if(unscaledHeight == 0){
				return ;
			}
			
//			if(unscaledHeight <unscaledWidth/2){
//				unscaledHeight=unscaledWidth/2;
//			}
			
			var f:IFill;
			var fillColor:Number;
//			if(!isNaN(color))	
//				fillColor = color;
//			else
//			{
				f = _wedge.fill;
				if(f is SolidColor)
				{
						fillColor = SolidColor(f).color;
				}
//			}
						
//			var fillColor:Number = color;
			var lighter:Number=Lighten(fillColor);
			var hsv:Object;
		
//			switch(mouseState)
//			{
//				case "over":
//					if (isNaN(overColor))
//					{
//						hsv = ColorUtils.RGBToHSV(fillColor);
//						hsv.v = Math.min(1,hsv.v*1.3);
//						hsv.s = hsv.s *.8;
//						fillColor = ColorUtils.HSVToRGB(hsv);
//						fillColor = overColor;
//					}
//					else
//					{
//						fillColor = overColor;
//					}
//					break;
//				case "down":
//					if(isNaN(downColor))
//					{
//						hsv = ColorUtils.RGBToHSV(fillColor);
//						hsv.v = hsv.v*.8;
//						hsv.s = hsv.s *.8;
//						fillColor = ColorUtils.HSVToRGB(hsv);
//						fillColor = downColor;
//					}
//					else
//					{
//						fillColor = downColor;
//					}
//					break;
//				default:
//					break;
//			}
		var stroke:IStroke = getStyle("stroke");				
		var w:Number = stroke ? stroke.weight / 2 : 0; 	
		
		if(height < width/2 ){
			var temHeight = height;
			var rc:Rectangle = new Rectangle(w, w, width - 2 * w, width/2 - 2 * w);
			setActualSize(width,width/2);
			trace("uicomponent x="+x+",y="+y);
			move(x,y-(width/2 -temHeight));

		}else{
			var rc:Rectangle = new Rectangle(w, w, width - 2 * w, height - 2 * w);
		}
		
			
			trace ("width="+ width+ ",height="+height + ",w="+w);
			
			var g:Graphics = graphics;
//		  if(rc.width>35){
//		  	rc.width=35;
//		  }
		 var aph:uint=1;//叠合柱子
		 
		 var wi:Number=rc.width;
		 var he:Number=rc.height;
		 var xx:Number=rc.width/2;
		 var ox:Number=rc.left+xx;
		 var oy:Number=rc.top;
		 
		 				
		
//		if(he < xx){
//			he=xx;
//			oy=0;
//		}
		 
		 
		 //==> wi=35,he=90,xx=17.5,ox=17.5,oy=0
		 trace("==> wi="+wi+",he="+he+",xx="+xx+",ox="+ox+",oy="+oy);

		 	var matrix:Matrix=new Matrix();
			g.clear();		
			g.moveTo(ox,oy);
			g.beginFill(fillColor);
			if (stroke)
		      stroke.apply(g);
		       var colors:Array=[lighter,fillColor];
				var alphas:Array=[aph,aph];
				var ratios:Array=[0,255];
				
				
				//====>
//				//画隐藏的三面
//				//隐藏的矩形
//				g.beginFill(fillColor,aph);
//				g.moveTo(ox,oy);
//			    g.lineTo(ox+wi,oy);
//			    g.lineTo(ox+wi,oy+he-xx);
//			    g.lineTo(ox,oy+he);
//				g.endFill();
//				
//				//隐藏的侧面
//				g.beginFill(fillColor,aph);
//				g.moveTo(ox-xx,oy+xx);
//			    g.lineTo(ox,oy);
//			    g.lineTo(ox,oy+he);
//			    g.lineTo(ox-xx,oy+he+xx);
//				g.endFill();
//				//隐藏的底面
//				g.beginFill(fillColor,aph);
//				g.moveTo(ox,oy+he);
//			    g.lineTo(ox+wi,oy+he-xx);
//			    g.lineTo(ox+wi-xx,oy+he+xx);
//			    g.lineTo(ox-xx,oy+he+xx);
//				g.endFill();
				//<====
				

				// 画柱体的上面部分
				matrix.createGradientBox(wi, xx, (270/180)*Math.PI, ox, oy);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
				graphics.moveTo(ox,oy); trace ("[up] move:"+ox+","+oy);
			    graphics.lineTo(ox+wi,oy);trace ("[up] lineto:"+( ox+wi)+","+oy);
			    graphics.lineTo(ox+wi-xx,oy+xx);trace ("[up] lineto:"+( ox+wi-xx)+","+(oy+xx));
			    graphics.lineTo(ox-xx,oy+xx);   trace ("[up] lineto:"+( ox-xx)+","+(oy+xx));
			    graphics.endFill();
			    
			    
		      // 画柱体的前面，
			 	colors = [lighter,fillColor];
				alphas = [1,1];
				ratios = [0,127];
				matrix.createGradientBox(wi, he, Math.PI/2, ox-xx, oy+xx);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
//			    g.drawRect(ox-xx,oy+xx,wi,he);
			    g.moveTo(ox-xx,oy+xx);trace ("[front side] move:"+(ox-xx)+","+(oy+xx));
			    g.lineTo(ox-xx+wi,oy+xx);trace ("[front side] move:"+(ox-xx+wi)+","+(oy+xx));
			    g.lineTo(ox-xx+wi,oy+xx+he);trace ("[front side] move:"+(ox-xx+wi)+","+(oy+xx+he));
			    g.lineTo(ox-xx,oy+xx+he);trace ("[front side] move:"+(ox-xx)+","+(oy+xx+he));
			    g.endFill();
			    
//			   //画右侧面
			   colors = [fillColor,lighter];
//				alphas = [0.7,0.7];
				alphas = [1,1];
				ratios = [0,255];
			    matrix.createGradientBox(xx, he+xx, (270/180)*Math.PI, ox+wi-xx, oy+xx);
				g.beginGradientFill("linear",colors,alphas,ratios,matrix);
//				g.beginFill(0x60cb00,1);
				//==> wi=35,he=90,xx=17.5,ox=17.5,oy=0
			    g.moveTo(ox+wi-xx,oy+xx);trace ("[r side] move:"+(ox+wi-xx)+","+(oy+xx));
			    g.lineTo(ox+wi,oy);trace ("[r side] lineto:"+( ox+wi)+","+oy);
			    
			    
//			    var origindrawHe = oy+he-xx ;
				var drawHe = oy+he-xx ;
			    if(drawHe < 0){
				    g.lineTo(ox+wi,0);trace ("[r side] lineto:"+( ox+wi)+","+(0));
	//			    g.lineTo(ox+wi,oy+he);
				    g.lineTo(ox+wi-xx,oy+xx);trace ("[r side] lineto:"+(ox+wi-xx)+","+(oy+xx));
			    }else{
			    	 g.lineTo(ox+wi,oy+he-xx);trace ("[r side] lineto:"+( ox+wi)+","+(oy+he-xx));
			    	 g.lineTo(ox+wi-xx,oy+he);trace ("[r side] lineto:"+(ox+wi-xx)+","+(oy+he));
			    }

			    g.endFill();
			   /**
				 * 如果有需要画后面，左侧面的话，画法和画前面，右侧面一样，只不过起始点不一样而已，大家可以自己画
				**/
		}
		
		public function getPoints(w:Number,h:Number,s:Number):Array
		{

			var points:Array = new Array(8);
			points[0] = new Point(0,w/s);
			points[1] = new Point(w,w/s);
			points[2] = new Point(w,h+w/s);
			points[3] = new Point(0,w/s+h);
			points[4] = new Point(w/s,0);
			points[5] = new Point(w+w/s,0);
			points[6] = new Point(w+w/s,h);
			points[7] = new Point(w/s,h);
			return points;
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
		
		
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{ 
////			unscaledWidth = 20 ;
////			unscaledHeight = 20 ;
//
//			super.updateDisplayList(unscaledWidth,unscaledHeight);
//			this.graphics.clear();
////			var points:Array = getPoints(unscaledWidth*0.20,unscaledHeight);
//			var points:Array = getPoints(unscaledWidth*0.65,unscaledHeight ,slope);
//			var aph:uint=1;//叠合柱子
//			var fillColor:Number = color;
//			var lighter:Number=Lighten(fillColor);
//			var hsv:Object;
//		       var colors:Array=[lighter,fillColor];
//				var alphas:Array=[aph,aph];
//				var ratios:Array=[0,255];
//			var matrix:Matrix=new Matrix();
//			
//			var w:Number,h:Number,s:Number ;
//			w=width - 2 * w;
//		    h=height - 2 * w;
//		    s = 3.0;
//			
//			matrix.createGradientBox(w, w/s, (270/180)*Math.PI, points[5].x, points[5].y);
//			graphics.beginGradientFill("linear",colors,alphas,ratios,matrix);
//			drawUpFill(points[5],points[4],points[0],points[1]);  // 上面
//			
//			
//			colors = [lighter,fillColor];
//			alphas = [1,1];
//				ratios = [0,127];
//				matrix.createGradientBox(w, h, Math.PI/2, points[0].x, points[0].y);
//				graphics.beginGradientFill("linear",colors,alphas,ratios,matrix);
//			drawFrontFill(points[0],points[3],points[2],points[1]);  // 正面
//			
//			
//			
//			colors = [fillColor,lighter];
//		alphas = [0.7,0.7];
//			alphas = [1,1];
//				ratios = [0,255];
//			    matrix.createGradientBox(w/s, h+w/s, (270/180)*Math.PI, points[1].x, points[1].y);
//				graphics.beginGradientFill("linear",colors,alphas,ratios,matrix);
//			
//			drawSideFill(points[1],points[2],points[6],points[5]);  // 侧面
//
//
//
//			
////			this.graphics.endFill();
//			
//		}
		
		//根据长宽获取3D坐标信息
//		public function getPoints(w:Number,h:Number,s:Number):Array
//		{
//			var points:Array = new Array(8);
//			points[0] = new Point(0,h);
//			points[1] = new Point(w,h);
//			points[2] = new Point(w,0);
//			points[3] = new Point(0,0);
//			points[4] = new Point(0+w/s,h+w/s);
//			points[5] = new Point(w+w/s,h+w/s);
//			points[6] = new Point(w+w/s,0+w/s);
//			points[7] = new Point(0+w/s,0+w/s);
//			return points;
//		}

		
		//根据传入的坐标信息，绘制线条及填充绘制区域
		public function drawUpFill(...args):void
		{
				//前面
//				graphics.lineStyle(0.5,0x7DBFC6,0.8);
//				graphics.beginFill(colors[(_chartItem == null)?0:_chartItem.index],0.3);

//				matrix.createGradientBox(w, w/s, (270/180)*Math.PI, ox, oy);
//				g.beginGradientFill("linear",colors,alphas,ratios,matrix);

				graphics.moveTo(args[0].x,args[0].y);
				trace("move to :"+ ",x="+args[0].x+",y="+args[0].y);
				for(var i:int=1;i<args.length;i++)
				{
					graphics.lineTo(args[i].x,args[i].y);
				trace("line to :"+ ",x="+args[i].x+",y="+args[i].y);
				}			
				graphics.endFill();	


		}
		
				public function drawFrontFill(...args):void
		{
//			with(this.graphics)
//			{
				//前面
//				graphics.lineStyle(0.5,0x7DBFC6,0.8);
//				graphics.beginFill(colors[(_chartItem == null)?0:_chartItem.index],0.3);

				graphics.moveTo(args[0].x,args[0].y);
				trace("move to :"+ ",x="+args[0].x+",y="+args[0].y);
				for(var i:int=1;i<args.length;i++)
				{
					graphics.lineTo(args[i].x,args[i].y);
				trace("line to :"+ ",x="+args[i].x+",y="+args[i].y);
				}			
				graphics.endFill();		
//			}
		}
		
		public function drawSideFill(...args):void
		{
//			with(this.graphics)
//			{
				//前面
//				graphics.lineStyle(0.5,0x7DBFC6,0.8);
//				graphics.beginFill(colors[(_chartItem == null)?0:_chartItem.index],0.3);

				graphics.moveTo(args[0].x,args[0].y);
				trace("move to :"+ ",x="+args[0].x+",y="+args[0].y);
				for(var i:int=1;i<args.length;i++)
				{
					graphics.lineTo(args[i].x,args[i].y);
				trace("line to :"+ ",x="+args[i].x+",y="+args[i].y);
				}			
				graphics.endFill();		
//			}
		}
		
	}


}
