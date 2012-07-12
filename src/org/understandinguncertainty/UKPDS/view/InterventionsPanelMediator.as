/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;
	import org.understandinguncertainty.UKPDS.components.InterventionCheck;
	import org.understandinguncertainty.UKPDS.components.InterventionStepper;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
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
		
		public function InterventionsPanelMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			
			// Set stepper limits
			interventionsPanel.hba1c.minimum = 5;
			interventionsPanel.hba1c.maximum = 11;
			
			interventionsPanel.sbp.minimum = 100;
			interventionsPanel.sbp.maximum = 220;

			interventionsPanel.totalCholesterol.minimum = 0.0000001;
			interventionsPanel.totalCholesterol.maximum = 20;

			interventionsPanel.hdlCholesterol.minimum = 0.0000001;
			interventionsPanel.hdlCholesterol.maximum = 12;
			
			var h2:Number = Math.pow(userProfile.height_m,2);
			interventionsPanel.weight_kg.minimum = h2*15;
			interventionsPanel.weight_kg.maximum = h2*45;
			
			interventionsPanel.smoker.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.smoker.addEventListener(MouseEvent.CLICK, resetSmoker);

			interventionsPanel.sbp.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.addEventListener(MouseEvent.CLICK, resetSBP);
			
			interventionsPanel.hba1c.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hba1c.addEventListener(MouseEvent.CLICK, resetHba1c);
			
			interventionsPanel.totalCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.addEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.addEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.weight_kg.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.weight_kg.addEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.active.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.active.addEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.resetButton.addEventListener(MouseEvent.CLICK, resetAll);
			
			interventionsPanel.conversionFactor = appState.mmol ? 1 : appState.mmolConvert;
			
			setInterventions();
		}
		
		override public function onRemove():void
		{
			interventionsPanel.sbp.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.sbp.removeEventListener(MouseEvent.CLICK, resetSBP);

			interventionsPanel.hba1c.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hba1c.removeEventListener(MouseEvent.CLICK, resetHba1c);
			
			interventionsPanel.totalCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.totalCholesterol.removeEventListener(MouseEvent.CLICK, resetTotalCholesterol);
			
			interventionsPanel.hdlCholesterol.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.hdlCholesterol.removeEventListener(MouseEvent.CLICK, resetHDLCholesterol);
			
			interventionsPanel.weight_kg.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.weight_kg.removeEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.active.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.active.removeEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.resetButton.removeEventListener(MouseEvent.CLICK, resetAll);
		}
		
		private function setInterventions():void
		{	
			interventionsPanel.smoker.original = interventionsPanel.smoker.selected = userProfile.smoker_int;
			interventionsPanel.sbp.original = interventionsPanel.sbp.value = userProfile.sbp_int;
			interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int;
			interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int;		
			interventionsPanel.smoker.original = interventionsPanel.smoker.selected = userProfile.smoker_int;
			interventionsPanel.hba1c.original = interventionsPanel.hba1c.value = userProfile.hba1c_int;
			interventionsPanel.weight_kg.original = interventionsPanel.weight_kg.value = userProfile.weight_kg_int;
			interventionsPanel.active.original = interventionsPanel.active.selected = userProfile.active_int;
				
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
			interventionsPanel.bmiField.text = "BMI: " + userProfile.bmi_int.toPrecision(3);
				
			model.recalculate();
		}
		
		private function stepperChanged(event:Event):void
		{
			userProfile.smoker_int = interventionsPanel.smoker.selected;
			userProfile.sbp_int = interventionsPanel.sbp.value;
			userProfile.totalCholesterol_int = interventionsPanel.totalCholesterol.value;
			userProfile.hdlCholesterol_int = interventionsPanel.hdlCholesterol.value;
			userProfile.hba1c_int = interventionsPanel.hba1c.value;
			userProfile.weight_kg_int = interventionsPanel.weight_kg.value;
			userProfile.active_int = interventionsPanel.active.selected;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
			
			model.recalculate();
		}
		/*
		private function futureSmokingChanged(event:Event):void 
		{

			userProfile.smoker_int = interventionsPanel.futureSmokingCategory.selectedIndex == 1;

			model.recalculate();
		}
		*/
		private function resetAll(event:MouseEvent):void
		{
			userProfile.resetInterventions();
		}
		
		private function resetSmoker(event:MouseEvent):void
		{
			
			interventionsPanel.smoker.original = userProfile.smoker_int = userProfile.smokerAtDiagnosis;
			model.recalculate();
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
		
		private function resetHba1c(event:MouseEvent):void
		{
			interventionsPanel.hba1c.value = userProfile.hba1c_int = userProfile.hba1c;
			model.recalculate();
		}
		
		private function resetWeight(event:MouseEvent):void
		{
			interventionsPanel.weight_kg.value = userProfile.weight_kg_int = userProfile.weight_kg;
			model.recalculate();
		}
		
		private function resetActive(event:MouseEvent):void
		{
			interventionsPanel.active.reset();
		}
		
	}
}