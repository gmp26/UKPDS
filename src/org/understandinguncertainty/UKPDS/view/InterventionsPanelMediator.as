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
			interventionsPanel.hba1c.minimum = Math.min(5, userProfile.hba1c);
			interventionsPanel.hba1c.maximum = Math.max(11, userProfile.hba1c);
			
			interventionsPanel.sbp.minimum = Math.min(100, userProfile.sbp);
			interventionsPanel.sbp.maximum = Math.max(220, userProfile.sbp);
			
			trace(userProfile.sbp, userProfile.sbp_int);

			interventionsPanel.totalCholesterol.minimum = Math.min(2, userProfile.totalCholesterol);
			interventionsPanel.totalCholesterol.maximum = Math.max(20, userProfile.totalCholesterol);

			interventionsPanel.hdlCholesterol.minimum = Math.min(0.2, userProfile.hdlCholesterol);
			interventionsPanel.hdlCholesterol.maximum = Math.max(12, userProfile.hdlCholesterol);
			
						
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
			
			interventionsPanel.overweight.label = "Is your weight over " + userProfile.weightLimit.toFixed(1) + " kg ?";
			interventionsPanel.overweight.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.overweight.addEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.active.addEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.active.addEventListener(MouseEvent.CLICK, resetActive);
			
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
			
			interventionsPanel.overweight.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.overweight.removeEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.active.removeEventListener(Event.CHANGE, stepperChanged);
			interventionsPanel.active.removeEventListener(MouseEvent.CLICK, resetWeight);
			
			interventionsPanel.resetButton.removeEventListener(MouseEvent.CLICK, resetAll);
		}
		
		private function setInterventions():void
		{	
			trace("setInterventions");
			
			interventionsPanel.smoker.original = interventionsPanel.smoker.selected = userProfile.smoker_int;
			interventionsPanel.sbp.original = interventionsPanel.sbp.value = userProfile.sbp_int;
			interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int;
			interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int;		
			interventionsPanel.smoker.original = interventionsPanel.smoker.selected = userProfile.smoker_int;
			interventionsPanel.hba1c.original = interventionsPanel.hba1c.value = userProfile.hba1c_int;
			interventionsPanel.overweight.original = interventionsPanel.overweight.selected = userProfile.overweight_int;
			interventionsPanel.active.original = interventionsPanel.active.selected = userProfile.active_int;
				
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
//			interventionsPanel.bmiField.text = "BMI: " + userProfile.bmi_int.toPrecision(3);
				
			model.recalculate();
		}
		
		private function stepperChanged(event:Event):void
		{
			userProfile.smoker_int = interventionsPanel.smoker.selected;
			userProfile.sbp_int = interventionsPanel.sbp.value;
			userProfile.totalCholesterol_int = interventionsPanel.totalCholesterol.value;
			userProfile.hdlCholesterol_int = interventionsPanel.hdlCholesterol.value;
			
			// ensure total >= hdl
			if(userProfile.totalCholesterol_int < userProfile.hdlCholesterol_int) {
				if(event.currentTarget == interventionsPanel.totalCholesterol) {
					userProfile.totalCholesterol_int = interventionsPanel.totalCholesterol.value = userProfile.hdlCholesterol_int;
				}
				else {
					userProfile.hdlCholesterol_int = interventionsPanel.hdlCholesterol.value = userProfile.totalCholesterol_int;					
				}
			}
			
			userProfile.hba1c_int = interventionsPanel.hba1c.value;
			userProfile.active_int = interventionsPanel.active.selected;
			userProfile.overweight_int = interventionsPanel.overweight.selected;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (userProfile.totalCholesterol_int - userProfile.hdlCholesterol_int).toPrecision(2);
			
			model.recalculate();
		}

		private function resetAll(event:MouseEvent = null):void
		{
			//userProfile.resetInterventions();
			interventionsPanel.smoker.selected = userProfile.smoker_int = userProfile.smokerAtDiagnosis;
			interventionsPanel.hba1c.value = userProfile.hba1c_int = userProfile.hba1c;
			interventionsPanel.sbp.value = userProfile.sbp_int = userProfile.sbp;
			interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int = userProfile.totalCholesterol;
			interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int = userProfile.hdlCholesterol;
			interventionsPanel.overweight.selected = userProfile.overweight_int = userProfile.overweight;
			interventionsPanel.active.selected = userProfile.active_int = userProfile.active;
			
			userProfile.nonZeroInterventions = false;
			model.recalculate();
		}
		
		private function resetSmoker(event:MouseEvent = null):void
		{
			interventionsPanel.smoker.selected = userProfile.smoker_int = userProfile.smokerAtDiagnosis;
			model.recalculate();
		}
		
		private function resetSBP(event:MouseEvent = null):void
		{
			interventionsPanel.sbp.value = userProfile.sbp_int = userProfile.sbp;
			model.recalculate();
		}
		
		private function resetTotalCholesterol(event:MouseEvent = null):void
		{
			interventionsPanel.totalCholesterol.value = userProfile.totalCholesterol_int = userProfile.totalCholesterol;
			model.recalculate();
		}
		
		private function resetHDLCholesterol(event:MouseEvent = null):void
		{
			interventionsPanel.hdlCholesterol.value = userProfile.hdlCholesterol_int = userProfile.hdlCholesterol;
			model.recalculate();
		}
		
		private function resetHba1c(event:MouseEvent = null):void
		{
			interventionsPanel.hba1c.value = userProfile.hba1c_int = userProfile.hba1c;
			model.recalculate();
		}
		
		private function resetWeight(event:MouseEvent = null):void
		{
			interventionsPanel.overweight.selected = userProfile.overweight_int = userProfile.overweight;
			model.recalculate();
		}
		
		private function resetActive(event:MouseEvent = null):void
		{
			interventionsPanel.active.selected = userProfile.active_int = userProfile.active;
			model.recalculate();
		}
		
	}
}