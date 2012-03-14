package com.dobodo.drawhelper
{
	public class Pie3Das
	{
		public function Pie3Das()
		{
		
		

			//存放shape对象
			private var __contain:Object;
			//设置角度从-90开始
			private var R:int=-90;
			private var D:uint=20;
			private var _shape:Shape;
			//初始饼图的圆心位置
			private var _x0:Number;
			private var _y0:Number;
			//椭圆饼图的长轴与短轴长度
			private var _a:Number;
			private var _b:Number;
			//饼图的厚度
			private var _h:Number;
			//透明度
			private var _alpha:Number
			//数据列表
			private var _dataList:Array;
			private var _colorList:Array;
			private var _angleList:Array;
			private var _depthList:Array;
			//
			/**
			*@param:x0......>圆心x坐标
			*@param:y0......>圆心y坐标
			*@param:a......>长轴
			*@param:b......>短轴
			*@param:h......>厚度
			*@param:dataList......>数据列表
			*@param:dataList......>颜色列表
			*@alpha:Number......>透明度,默认为1.0
			*/
			public function DrawPieGraph(x0:Number,y0:Number,a:Number,b:Number,h:Number,
			dataList:Array,colorList:Array,alpha:Number=1.0) {
			_x0=x0;
			_y0=y0;
			_a=a;
			_b=b;
			_h=h;
			_alpha=alpha
			
			_dataList=dataList;
			_colorList=colorList;
			setAngleList();
			drawPie();
			setDepths();
			}
private function setAngleList():void {
_angleList=[];
var totalData:int;
var len:uint=_dataList.length;
for (var j:uint=0; j < len; j ) {
totalData = _dataList[j];
}
for (j=0; j < len; j ) {
if (j == len - 1) {
_angleList.push([R,270]);
} else {
var r:uint=Math.floor(_dataList[j] / totalData * 360);
var posR:int=R r;
_angleList.push([R,posR]);
R=posR;
trace(r "___r");
trace(R);
}
}
trace(_angleList ":::");
}
private function setDepths():void {
_depthList=[];
var len:uint=_angleList.length;
for (var j:uint=0; j < len; j ) {
var minJ:Number=_angleList[j][0];
var maxJ:Number=_angleList[j][1];
switch (true) {
case minJ >= -90 && minJ <= 90 && maxJ<=90 :
_depthList[j]=minJ;
break;
default :
_depthList[j]=1000-minJ;
}
}//end for
trace(_depthList "::::_depthList");
_depthList=_depthList.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
trace(_depthList);
for (j=0; j<len; j ) {
setChildIndex(__contain["shape" _depthList[j]],j);
}
}


private function drawPie():void {
__contain={};
var len:uint=_angleList.length;
var step:uint=1;
for (var j:uint=0; j < len; j ) {
__contain["shape" j]=new MovieClip;
//设置中心角，方便以下进行点中移动
__contain["shape" j].r=(_angleList[j][0] _angleList[j][1])/2;
__contain["shape" j].addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX);
addChild(__contain["shape" j]);
var drakColor:uint=getDarkColor(_colorList[j]);//深色
var g:Graphics=__contain["shape" j].graphics;
//g.lineStyle(1);
//先画底
//内弧
g.beginFill(_colorList[j],_alpha);
g.moveTo(_x0,_y0 _h);
var r:Number=_angleList[j][0];
var minR:Number=r;
var maxR:int=_angleList[j][1];
while (r step < maxR) { g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,r).x,getRPoint(_x0,_y0 _h,_a,_b,r).y);
r = step;
}
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,maxR).x,getRPoint(_x0,_y0 _h,_a,_b,maxR).y);
//
g.endFill();
//画内侧面
g.beginFill(drakColor,_alpha);
g.moveTo(_x0,_y0 _h);
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,minR).x,getRPoint(_x0,_y0 _h,_a,_b,minR).y);
g.lineTo(getRPoint(_x0,_y0,_a,_b,minR).x,getRPoint(_x0,_y0,_a,_b,minR).y);
g.lineTo(_x0,_y0);
g.endFill();
//画外侧面
g.beginFill(drakColor,_alpha);
g.moveTo(_x0,_y0 _h);
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,maxR).x,getRPoint(_x0,_y0 _h,_a,_b,maxR).y);
g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y);
g.lineTo(_x0,_y0);
g.endFill();
//画外弧侧面
g.beginFill(drakColor,_alpha);
//g.lineStyle(1);
g.moveTo(getRPoint(_x0,_y0 _h,_a,_b,minR).x,getRPoint(_x0,_y0 _h,_a,_b,minR).y);
g.lineTo(getRPoint(_x0,_y0,_a,_b,minR).x,getRPoint(_x0,_y0,_a,_b,minR).y);
r=minR;
while (r step < maxR) {
r = step;
g.lineTo(getRPoint(_x0,_y0,_a,_b,r).x,getRPoint(_x0,_y0,_a,_b,r).y);
}
g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y);
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,maxR).x,getRPoint(_x0,_y0 _h,_a,_b,maxR).y);
while (r - step > minR) {
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,r).x,getRPoint(_x0,_y0 _h,_a,_b,r).y);
r-= step;
}
g.lineTo(getRPoint(_x0,_y0 _h,_a,_b,minR).x,getRPoint(_x0,_y0 _h,_a,_b,minR).y);
g.endFill();
//画上表面
g.beginFill(_colorList[j],_alpha);
g.moveTo(_x0,_y0);
r=minR;
while (r step < maxR) {

g.lineTo(getRPoint(_x0,_y0,_a,_b,r).x,getRPoint(_x0,_y0,_a,_b,r).y);
r = step;
}
g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y);
g.endFill();
}
}
private function onMouseDownX(e:MouseEvent):void {
var TG:MovieClip=e.target as MovieClip;
var posX:int=getRPoint(0,0,D,D,TG.r).x;
var posY:int=getRPoint(0,0,D,D,TG.r).y;
if (TG.x==0 || TG.y==0) {
TG.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX);
var tween1=new Tween(TG,"x",Bounce.easeOut,0,posX,1,true);
var tween2=new Tween(TG,"y",Bounce.easeOut,0,posY,1,true);
tween1.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish);
} else {
TG.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX);
var tween3=new Tween(TG,"x",Bounce.easeOut,TG.x,0,1,true);
var tween4=new Tween(TG,"y",Bounce.easeOut,TG.y,0,1,true);
tween3.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish);
}
}
private function onMotionFinish(e:TweenEvent):void {
var TG:MovieClip=e.currentTarget.obj as MovieClip;
TG.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX);
}
private function getDarkColor(color:uint):uint {
var r:uint=color >> 16 & 0xFF / 1.3;
var g:uint=color >> 8 & 0xFF / 1.3;
var b:uint=color & 0xFF /1.1;
return r << 16 | g << 8 | b;
}
private function getRPoint(x0:Number,y0:Number,a:Number,b:Number,r:Number):Object {
r=r * Math.PI / 180;
return {x:Math.cos(r) * a x0,y:Math.sin(r) * b y0};
}
public function get contain():Object {
return __contain;
}
}


}