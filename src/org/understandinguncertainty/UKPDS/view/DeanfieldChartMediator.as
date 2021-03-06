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
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	
	import spark.components.RichText;
	
	public class DeanfieldChartMediator extends Mediator
	{
		[Inject]
		public var outlookChart:DeanfieldChart;
		
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		private const interventionColour:uint = 0x000000;
		private const targetColour:uint = 0xcc0000;
		
		override public function onRegister() : void
		{
			//trace("DeanfieldChart register");
			modelUpdatedSignal.add(updateView);

			model.recalculate();
			outlookChart.areaChart.dataProvider=model.getResultSet();
		}
		
		override public function onRemove():void
		{
			//trace("DeanfieldChart remove");
			modelUpdatedSignal.remove(updateView);
		}
		
		public var gainedLost:String;
	
		private function updateView():void
		{

			if(appState.selectedScreenName != "deanfield") {				
				return;
			}

			outlookChart.areaChart.dataProvider = model.getResultSet();
			outlookChart.ageAxis.minimum = appState.minimumAge;

			annotate();
			
			outlookChart.gainLabel.visible = false;
			outlookChart.lossLabel.visible = false;
			if(model.yearGain > 0.1) {
				outlookChart.yearGain.text = model.yearGain.toPrecision(2);
				gainedLost = "gained"
				outlookChart.gainLabel.visible = true;
			}
			else if(model.yearGain < -0.1) {
				outlookChart.yearLoss.text = (-model.yearGain).toPrecision(2);
				gainedLost = "lost"					
				outlookChart.lossLabel.visible = true;
			}
			
			outlookChart.areaChart.dataTipFunction = dataTipFunction;
			outlookChart.chanceAxis.labelFunction = addPercent;
		}
		
		private function annotate(event:Event = null):void
		{
			outlookChart.dataCanvas.clear();
			outlookChart.dataCanvas.removeAllChildren();
			
			outlookChart.dataCanvas.lineStyle(2, interventionColour, 0.6);
			
			var intAge:int = appState.interventionAge; //interventionSlider.value;
			outlookChart.areaChart.validateNow();					// so chanceAxis scales are correct here
			outlookChart.dataCanvas.moveTo(intAge, outlookChart.chanceAxis.minimum);
			outlookChart.dataCanvas.lineTo(intAge, outlookChart.chanceAxis.maximum);
			
			var intLabel:RichText = new RichText();
			intLabel.text = "Intervention Start Age";
			intLabel.setStyle("fontSize", 14);
			intLabel.setStyle("color", interventionColour);
			intLabel.alpha = 0.6;
			intLabel.rotation = -90;
			outlookChart.dataCanvas.addDataChild(intLabel, intAge+0.2, (outlookChart.chanceAxis.minimum + outlookChart.chanceAxis.maximum)/4);
			
			// Add mean survival age 
			outlookChart.meanAgeText.text = model.meanAge.toPrecision(3) + " years";
			outlookChart.dataCanvas.addDataChild(outlookChart.meanAgeLabel,
				null,
				null, 
				null,
				0,
				model.meanAge);
			
			if(model.yearGain > 0.1) {
				var labelAge:int = Math.round((appState.interventionAge+100)/2);
				var dp:ArrayCollection = outlookChart.areaChart.dataProvider as ArrayCollection;
				var labelIndex:int = labelAge - appState.minimumAge;
				if(labelIndex > 0 && labelIndex < dp.length) {
					var item:Object = dp.getItemAt(labelIndex);
					outlookChart.dataCanvas.addDataChild(outlookChart.gainLabel,null,100, null,null,labelAge, null);
				}
			}
			else if(model.yearGain < 0.1) {
				labelAge = Math.round((appState.interventionAge+100)/2);
				dp = outlookChart.areaChart.dataProvider as ArrayCollection;
				labelIndex = labelAge - appState.minimumAge;
				if(labelIndex > 0 && labelIndex < dp.length) {
					item = dp.getItemAt(labelIndex);
					outlookChart.dataCanvas.addDataChild(outlookChart.lossLabel,null,100, null,null,labelAge, null);
				}				
			}
		}

		private function dataTipFunction(hitData:HitData):String
		{
			var item:Object = hitData.item;
			var color:int = hitData.contextColor;
			var s:String = "Age: " + item.age.toFixed(0) + "\n";
			switch(hitData.contextColor) {
				case outlookChart.goodFill.color:
					s += "% Chance of Survival with no\nHeart Attack or Stroke: " + (item.green.toFixed(0)) + "%";
					break;
				case outlookChart.badFill.color:
					s += "Cumulative % Risk of Heart\nAttack or Stroke: " + (item.redOnly.toFixed(0)) + "%";
					break;
				case outlookChart.betterFill.color:
					s += "Improvement due to intervention: " +  Math.max(0, item.yellowOnly).toFixed(0) + "%";
			}
			
			return s;
		}
		
		private function addPercent(rounded:Number, oldValue:Number, axis:LinearAxis):String
		{
			return rounded.toFixed(0).replace(/\./,"") + "%";
		}

	}
}