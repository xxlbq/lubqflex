package com.dobodo.drawhelper
{
import mx.charts.effects.SeriesEffect;
import mx.effects.IEffectInstance;
import mx.effects.TweenEffect;

public class DrillDownEffect extends TweenEffect
{
public function DrillDownEffect(target:Object = null)
{
super(target);
instanceClass = DrillDownEffectInstance;
}

public var drillFromIndex:Number = 0;
public var splitDirection:String = "vertical";


override protected function initInstance(inst:IEffectInstance):void
{
super.initInstance(inst);

DrillDownEffectInstance(inst).drillFromIndex = drillFromIndex;
DrillDownEffectInstance(inst).splitDirection = splitDirection;
}

}

}