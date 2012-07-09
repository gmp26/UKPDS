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
		
//		public var interventionProfile:UserModel;
		
		[Inject]
		public var runModel:ICardioModel;
		
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
			
			setInterventions(interventionProfile.variableList);
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
		
		private function setInterventions(user:VariableList):void
		{	
			interventionsPanel.sbp.original = interventionsPanel.sbp.value = user.systolicBloodPressure.value as Number;
			
			interventionsPanel.totalCholesterol.original = interventionsPanel.totalCholesterol.value = user.totalCholesterol_mmol_L.value;
			interventionsPanel.hdlCholesterol.original = interventionsPanel.hdlCholesterol.value = user.hdlCholesterol_mmol_L.value;
			
// TODO			interventionsPanel.futureSmokingCategory.selectedIndex = user.smokerAtDiagnosis.value as Number;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (user.totalCholesterol_mmol_L.value - user.hdlCholesterol_mmol_L.value).toPrecision(2);
			
			interventionsPanel.bmiField.text = "BMI: " + user.bmi.toPrecision(3);
				
			runModel.commitProperties();
		}
		
		private function stepperChanged(event:Event):void
		{
			var conversion:Number = appState.mmol ? 1 : 1/appState.mmolConvert;
			var inter:VariableList = interventionProfile.variableList;
			
			inter.systolicBloodPressure.value = interventionsPanel.sbp.value;
			inter.totalCholesterol_mmol_L.value = interventionsPanel.totalCholesterol.value;
			inter.hdlCholesterol_mmol_L.value = interventionsPanel.hdlCholesterol.value;
// TODO			inter.smokerGroup.value = interventionsPanel.futureSmokingCategory.selectedIndex;
			
			interventionsPanel.nonHDLField.text = "NonHDL Cholesterol: " + (inter.totalCholesterol_mmol_L.value - inter.hdlCholesterol_mmol_L.value).toPrecision(2);
			
			runModel.commitProperties();
		}
		
		private function futureSmokingChanged(event:Event):void 
		{
			var inter:VariableList = interventionProfile.variableList;

			var newSmokerCategory:int = interventionsPanel.futureSmokingCategory.selectedIndex;
			var oldSmokerCategory:int = userProfile.smoke_cat;
			if(oldSmokerCategory > 0 && newSmokerCategory == 0)
				newSmokerCategory = 1;
			if(oldSmokerCategory == 0 && newSmokerCategory == 1)
				newSmokerCategory = 0;
			interventionsPanel.futureSmokingCategory.selectedIndex = newSmokerCategory;
//TODO			inter.smokerGroup.value = newSmokerCategory;			

			runModel.commitProperties();
		}
		
		private function resetAll(event:MouseEvent):void
		{
			interventionProfile.variableList = userProfile.variableList.clone();
			setInterventions(userProfile.variableList);
		}
		
		private function resetSBP(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.systolicBloodPressure.value = user.systolicBloodPressure.value;
			interventionsPanel.sbp.value = user.systolicBloodPressure.value as Number;

			runModel.commitProperties();
		}
		
		private function resetTotalCholesterol(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.totalCholesterol_mmol_L = user.totalCholesterol_mmol_L;

			runModel.commitProperties();
			
		}
		
		private function resetHDLCholesterol(event:MouseEvent):void
		{
			var user:VariableList = userProfile.variableList;
			interventionProfile.variableList.hdlCholesterol_mmol_L = user.totalCholesterol_mmol_L;

			runModel.commitProperties();
			
		}
		
	}
}