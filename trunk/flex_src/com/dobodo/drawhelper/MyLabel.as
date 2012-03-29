package com.dobodo.drawhelper
{
import mx.charts.ChartItem;    
    import mx.core.IDataRenderer;    
    import mx.controls.Label;    
    import mx.core.UIComponent;    
    import mx.charts.series.LineSeries;    
    import mx.charts.series.items.LineSeriesItem;    
    import flash.display.Graphics;    
    import flash.geom.Rectangle;    
    import mx.charts.chartClasses.GraphicsUtilities;    
    import mx.core.IDataRenderer;    
    import mx.graphics.IFill;    
    import mx.graphics.IStroke;    
    import mx.skins.ProgrammaticSkin;    
    import mx.controls.Label;    
    import mx.core.UIComponent;    
    import mx.charts.renderers.*;
    import mx.utils.ColorUtil;
    import mx.styles.StyleManager;
    import mx.graphics.SolidColor;

    public class MyLabel extends UIComponent  implements IDataRenderer      //IDataRenderer
    {    
        private var _label:Label;    
            
        public function MyLabel():void   
        {    
            super();    
            _label = new Label(); 
            // _label.setStyle("itemRenderer", new  mx.core.ClassFactory(TriangleItemRenderer)); 
           
            addChild(_label);  
          
          // new mx.core.UIComponent().addChild(_label);
          // CircleItemRenderer(). 
            _label.setStyle("color",0x999999);    
            _label.setStyle("fontSize",12); 
            _label.setStyle("paddingTop",4);    
            
        _label.setStyle("itemRenderer", new  mx.core.ClassFactory(TriangleItemRenderer));     
        }    
        private var _chartItem:ChartItem;    
       private var _data:Object;
           private static var rcFill:Rectangle = new Rectangle();
        public   function  get data():Object    
        {    
            return _chartItem;    
        }    
       
        public   function set data(value:Object):void   
        {    
            if (_chartItem == value)    
                return;    
            _chartItem = ChartItem(value);    
       
            if(_chartItem != null)    
                _label.text = LineSeriesItem(_chartItem).yValue.toString();    
        }    
          
        override protected function updateDisplayList(unscaledWidth:Number,    
                                                      unscaledHeight:Number):void   
        {    
            super.updateDisplayList(unscaledWidth, unscaledHeight);    
                        
            _label.setActualSize(_label.getExplicitOrMeasuredWidth(),_label.getExplicitOrMeasuredHeight());  
            
            var fill:IFill;
        var state:String = "";
        _data = _chartItem;
        if(_data is ChartItem && _data.hasOwnProperty('fill'))
        {
            fill = _data.fill;
            state = _data.currentState;
        }         
        else
             fill = GraphicsUtilities.fillFromStyle(getStyle('fill'));
        
           var color:uint;
        var adjustedRadius:Number = 0;
        
        switch(state)
        {
            case ChartItem.FOCUSED:
            case ChartItem.ROLLOVER:
                if(StyleManager.isValidStyleValue(getStyle('itemRollOverColor')))
                    color = getStyle('itemRollOverColor');
                else
                    color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20);
                fill = new SolidColor(color);
                adjustedRadius = getStyle('adjustedRadius');
                if(!adjustedRadius)
                    adjustedRadius = 0;
                break;
            case ChartItem.DISABLED:
                if(StyleManager.isValidStyleValue(getStyle('itemDisabledColor')))
                    color = getStyle('itemDisabledColor');
                else    
                    color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),20);
                fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
                break;
            case ChartItem.FOCUSEDSELECTED:
            case ChartItem.SELECTED:
                if(StyleManager.isValidStyleValue(getStyle('itemSelectionColor')))
                    color = getStyle('itemSelectionColor');
                else
                    color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-30);
                fill = new SolidColor(color);
                adjustedRadius = getStyle('adjustedRadius');
                if(!adjustedRadius)
                    adjustedRadius = 0;
                break;
        }
  
        var stroke:IStroke = getStyle("stroke");
                
        var w:Number = stroke ? stroke.weight / 2 : 0;

        var cx:Number = unscaledWidth / 2;

        rcFill.left = rcFill.left - adjustedRadius;
        rcFill.top = rcFill.top - adjustedRadius
        rcFill.right = unscaledWidth + adjustedRadius;
        rcFill.bottom = unscaledHeight + adjustedRadius;

        var g:Graphics = graphics;
        g.clear();        
        g.moveTo(w, w);
        if (stroke)
            stroke.apply(g);
        g.moveTo(w - adjustedRadius, unscaledHeight - w + adjustedRadius);
//        if (fill)
            fill.begin(g, rcFill);
        g.lineTo(cx, w - adjustedRadius);
        g.lineTo(unscaledWidth - w + adjustedRadius, unscaledHeight - w + adjustedRadius);
        g.lineTo(w - adjustedRadius, unscaledHeight - w + adjustedRadius);
//        if (fill)
            fill.end(g);  
        }    
       
    } 
}