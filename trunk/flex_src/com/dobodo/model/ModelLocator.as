package com.dobodo.model
{
	import mx.collections.ArrayCollection;
	public class ModelLocator
	{
		static private var __instance:ModelLocator=null;
		[Bindable]
		public var BookAC:ArrayCollection = new ArrayCollection();
		static public function getInstance():ModelLocator
		{
			if(__instance == null)
			{
				__instance=new ModelLocator();
			}
			return __instance;
		}
	}
}