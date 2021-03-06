/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	
	import mx.charts.HitData;
	import mx.charts.LinearAxis;
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	
	public class CompareMediator extends Mediator
	{
		[Inject]
		public var compare:Compare;
		
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var userProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		override public function onRegister() : void
		{
			//trace("compare register");
			modelUpdatedSignal.add(updateView);
			compare.maxChance.addEventListener(Event.CHANGE, maxChanceChanged);
			compare.vAxis.labelFunction = addPercent;
			compare.chart.dataTipFunction = dataTipFunction;
			model.recalculate();
		}
		
		override public function onRemove():void
		{
			//trace("compare remove");
			modelUpdatedSignal.remove(updateView);
			compare.maxChance.removeEventListener(Event.CHANGE, maxChanceChanged);
		}
		
		[Bindable]
		public var dp:ArrayCollection;
		
		private var maxPercent:Number;
		
		private function updateView() : void
		{				
			if(appState.selectedScreenName != "compare") {
				
				// flashScore_gp may not be valid
				return;
			}
			
			var targetAge:int = userProfile.age + appState.targetInterval;
			var dp:ArrayCollection = model.getResultSet();
			
			compare.titleLabel.text = compare.title1 + " " + appState.targetInterval + " " 
				+ compare.title2 + " " + (appState.minimumAge + appState.targetInterval)
				+ compare.title3;
			
			compare.series.displayName = compare.displayName1 + " " + appState.targetInterval + " " + compare.displayName2;
			
			var targetItem:Object = dp.getItemAt(appState.targetInterval);
			
			var f:Number = Math.round(targetItem.fdash);
			var f_int:Number = Math.round(targetItem.fdash_int);
			var f_gp:Number = Math.round(targetItem.f_gp);
			
			compare.chart.dataProvider = new ArrayCollection([
				{category:"Without\nIntervention", risk:f},
				{category:"With\nIntervention", risk: f_int},
				{category:"General\nPopulation", risk:f_gp}
			]);
			
			maxPercent = 10*Math.ceil(Math.max(Math.max(f_gp, f_int), f)/10);
			compare.vAxis.maximum = Math.min(100,100 + maxPercent - compare.maxChance.value);
		}
		
		private function maxChanceChanged(event:Event):void {
			compare.vAxis.maximum = Math.min(100,100 + maxPercent - compare.maxChance.value);
			updateView();
		}
		
		private function addPercent(rounded:Number, oldValue:Number, axis:LinearAxis):String
		{
			return rounded.toFixed(0).replace(/\./,"") + "%";
		}
		
		
		private function dataTipFunction(hitData:HitData):String
		{
			var item:Object = hitData.item;
			var s:String = item.risk.toFixed(0) + "% ";
			s += "chance of Heart Attack or Stroke\nwithin " + appState.targetInterval 
			s += " years ";
			if(item.category == 'General\nPopulation') {
				s += "for people of the same\nage, gender, and ethnicity as you.";
			}
			else {
				s += (item.category as String).replace(/\n/," ").toLowerCase();
			}
			return s;
		}
		

	}
}