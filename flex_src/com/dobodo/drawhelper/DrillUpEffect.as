package com.dobodo.drawhelper
{
import mx.charts.effects.SeriesEffect;
import mx.effects.IEffectInstance;
import mx.effects.TweenEffect;

public class DrillUpEffect extends TweenEffect
{
public function DrillUpEffect(target:Object = null)
{
super(target);
instanceClass = DrillUpEffectInstance;
}
public var drillToIndex:Number = 0;


override protected function initInstance(inst:IEffectInstance):void
{
super.initInstance(inst);

DrillUpEffectInstance(inst).drillToIndex = drillToIndex;
}

}
}