/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.components.InterventionCheck;
	import org.understandinguncertainty.UKPDS.components.InterventionStepper;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.signals.InterventionEditedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;
	
	public class InterventionsPanelMediator extends Mediator
	{
		[Inject]
		public var interventionsPanel:InterventionsPanel;
		
		[Inject]
		public var userProfile:UserModel;
				
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var interventionEditedSignal:InterventionEditedSignal;
		
		public function InterventionsPanelMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			
			// Set stepper limits
			interventionsPanel.hba1c.minimum = 4;
			interventionsPanel.hba1c.maximum = 6
			
			interventionsPanel.sbp.minimum = 100;
			interventionsPanel.sbp.maximum = 220;

			interventionsPanel.totalCholesterol.minimum = 0.0000001;
			interventionsPanel.totalCholesterol.maximum = 20;

			interventionsPanel.hdlCholesterol.minimum = 0.0000001;
			interventionsPanel.hdlCholesterol.maximum = 12;
			
			interventionsPanel.sbp.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.addEventListener(MouseEvent.CLICK, resetSBP);
			
			interventionsPanel.totalCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.addEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.addEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.resetButton.addEventListener(MouseEvent.CLICK, resetAll);
			
			interventionsPanel.futureSmokingCategory.dataProvider = new ArrayCollection([
				"Non Smoker",
				"Smoker"
			]);
			interventionsPanel.futureSmokingCategory.addEventListener(Event.CHANGE, futureSmokingChanged);

			
			interventionsPanel.conversionFactor = appState.mmol ? 1 : appState.mmolConvert;
			
			
			setInterventions();
		}
		
		override public function onRemove():void
		{
			interventionsPanel.sbp.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.removeEventListener(MouseEvent.CLICK, resetSBP);

			interventionsPanel.totalCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.removeEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.removeEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.resetButton.removeEventListener(MouseEvent.CLICK, resetAll);
		}
		
		private function setInterventions():void
		{	
			interventionsPanel.sbp.original = interventionsPanel.sbp.value = userProfile.sbp_int;
			interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int;
			interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int;		
			interventionsPanel.futureSmokingCategory.selectedIndex = userProfile.smoker_int ? 1 : 0;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
			interventionsPanel.bmiField.text = "BMI: " + userProfile.bmi_int.toPrecision(3);
				
			model.recalculate();
		}
		
		private function stepperChanged(event:Event):void
		{
			var conversion:Number = appState.mmol ? 1 : 1/appState.mmolConvert;
			
			userProfile.sbp_int = interventionsPanel.sbp.value;
			userProfile.totalCholesterol_int = interventionsPanel.totalCholesterol.value;
			userProfile.hdlCholesterol_int = interventionsPanel.hdlCholesterol.value;
			userProfile.smoker_int = interventionsPanel.futureSmokingCategory.selectedIndex == 1;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
			
			model.recalculate();
		}
		
		private function futureSmokingChanged(event:Event):void 
		{

			userProfile.smoker_int = interventionsPanel.futureSmokingCategory.selectedIndex == 1;

			model.recalculate();
		}
		
		private function resetAll(event:MouseEvent):void
		{
			userProfile.resetInterventions();
		}
		
		private function resetSBP(event:MouseEvent):void
		{
			
			interventionsPanel.sbp.value = userProfile.sbp_int = userProfile.sbp;
			model.recalculate();
		}
		
		private function resetTotalCholesterol(event:MouseEvent):void
		{
			
			interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int = userProfile.totalCholesterol;
			model.recalculate();
			
		}
		
		private function resetHDLCholesterol(event:MouseEvent):void
		{
			interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int = userProfile.hdlCholesterol;
			model.recalculate();
			
		}
		
	}
}