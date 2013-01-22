/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.managers.ToolTipManager;
	import mx.validators.DateValidator;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.UKPDS.support.ProfileLoader;
	import org.understandinguncertainty.UKPDS.validators.DateOfBirthValidator;
	import org.understandinguncertainty.UKPDS.validators.DateOfDiagnosisValidator;
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.signals.NextScreenSignal;
	import org.understandinguncertainty.personal.signals.ProfileCommitSignal;
	import org.understandinguncertainty.personal.signals.ProfileDefaultsLoadedSignal;
	import org.understandinguncertainty.personal.signals.ProfileLoadSignal;
	import org.understandinguncertainty.personal.signals.ProfileSaveSignal;
	import org.understandinguncertainty.personal.signals.ProfileValidSignal;
	
	import spark.components.NumericStepper;
	
	public class UKPDSProfileMediator extends Mediator
	{
		
		[Inject]
		public var profile:UKPDSProfile;
		
		[Inject]
		public var profileValidSignal:ProfileValidSignal;
		
		[Inject]
		public var profileLoadSignal:ProfileLoadSignal;
		
		[Inject]
		public var profileSaveSignal:ProfileSaveSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var nextScreenSignal:NextScreenSignal;
		
		[Inject]
		public var userProfile:UserModel;
				
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var profileDefaultsLoadedSignal:ProfileDefaultsLoadedSignal;

		private var ps:PersonalisationFileStore;
		
		override public function onRegister():void
		{
			//trace("Profile Register");
			ps = userProfile.personalData;

			// Ethnic group selection (should chinese be 'far eastern' ? 
			profile.ethnicGroup.dataProvider = new ArrayCollection([
				"White or not stated",
				"Indian",
				"Pakistani",
				"Bangladeshi",
				"Other Asian",
				"Black Caribbean",
				"Black African",
				"Chinese",
				"Other ethnic group"
				]);
			
			
			profile.smokerGroup.dataProvider = new ArrayCollection([
				"No",
				"Yes"
				]);
			
			profile.cholUnits.dataProvider = cholUnitFactors;
			profile.hbA1cUnits.dataProvider = hba1cUnits;
			profile.hbA1cUnits.selectedIndex = appState.hbA1c_Percent ? 0 : 1;
			
			profile.cholUnits.selectedIndex = 0;
			appState.mmol = (cholesterolUnit == mmol_L);				
			
			validate();
			addEventListeners();
			
			// in case default loading happens first
			showPersonalData();
			
			// and in case it doesn't
			profileDefaultsLoadedSignal.add(showPersonalData);
			
			profile.hba1cStepper.stepSize = 0.1;
			/*
			profile.hba1cStepper.valueParseFunction = function(s:String):Number {
				return Number(s);
			}
			*/
			
			profile.hba1cStepper.valueFormatFunction = function(val:Number):String 
			{
				return appState.hbA1c_Percent ? val.toFixed(1) : val.toFixed(0);
			};

				

			//loadFromURL();
		}
		
		override public function onRemove():void
		{
			removeEventListeners();
			//model.commitProperties();
		}
		
		private function addEventListeners():void {
			profileCommitSignal.add(commitProfile);
			profileLoadSignal.add(loadPersonalDetails);
			profileSaveSignal.add(savePersonalDetails);
			
			//profile.cvdAlready.addEventListener(Event.CHANGE, validate);
			//profile.termsCheckbox.addEventListener(Event.CHANGE, validate);
			//.termsButton.addEventListener(MouseEvent.CLICK, visitTerms);
			
			profile.ddStep.addEventListener(Event.CHANGE, validate);
			profile.mmStep.addEventListener(Event.CHANGE, validate);
			profile.yyyyStep.addEventListener(Event.CHANGE, validate);
			
			//profile.diagnosisDdStep.addEventListener(Event.CHANGE, validate);
			profile.diagnosisMmStep.addEventListener(Event.CHANGE, validate);
			profile.diagnosisYyyyStep.addEventListener(Event.CHANGE, validate);
			
			profile.height_mStep.addEventListener(Event.CHANGE, validate);
			profile.weight_kgStep.addEventListener(Event.CHANGE, validate);
			
			profile.totalCholesterolStep.addEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolStep.addEventListener(Event.CHANGE, validate);
			profile.systolicBloodPressureInputStep.addEventListener(Event.CHANGE, validate);
			profile.hba1cStepper.addEventListener(Event.CHANGE, validate);
			
			profile.cholUnits.addEventListener(Event.CHANGE, changedUnits);
			profile.hbA1cUnits.addEventListener(Event.CHANGE, change_hba1c_units);
			
			//profile.saveButton.addEventListener(MouseEvent.CLICK, save);
			//profile.loadButton.addEventListener(MouseEvent.CLICK, load);
			profile.nextButton.addEventListener(MouseEvent.CLICK, nextScreen);	
			
		}
		
		private function removeEventListeners():void {
			profileCommitSignal.remove(commitProfile);
			profileLoadSignal.remove(loadPersonalDetails);
			profileSaveSignal.remove(savePersonalDetails);

			//profile.cvdAlready.removeEventListener(Event.CHANGE, validate);
			//profile.termsCheckbox.removeEventListener(Event.CHANGE, validate);
			//profile.termsButton.removeEventListener(MouseEvent.CLICK, visitTerms);

			profile.ddStep.removeEventListener(Event.CHANGE, validate);
			profile.mmStep.removeEventListener(Event.CHANGE, validate);
			profile.yyyyStep.removeEventListener(Event.CHANGE, validate);
			
			//profile.diagnosisDdStep.removeEventListener(Event.CHANGE, validate);
			profile.diagnosisMmStep.removeEventListener(Event.CHANGE, validate);
			profile.diagnosisYyyyStep.removeEventListener(Event.CHANGE, validate);
			
			profile.height_mStep.removeEventListener(Event.CHANGE, validate);
			profile.weight_kgStep.removeEventListener(Event.CHANGE, validate);
			
			profile.totalCholesterolStep.removeEventListener(Event.CHANGE, validate);
			profile.hdlCholesterolStep.removeEventListener(Event.CHANGE, validate);
			profile.systolicBloodPressureInputStep.removeEventListener(Event.CHANGE, validate);
			profile.hba1cStepper.removeEventListener(Event.CHANGE, validate);
			
			profile.cholUnits.removeEventListener(Event.CHANGE, changedUnits);
			profile.hbA1cUnits.removeEventListener(Event.CHANGE, change_hba1c_units);
			
			//profile.saveButton.removeEventListener(MouseEvent.CLICK, save);
			//profile.loadButton.removeEventListener(MouseEvent.CLICK, load);
			profile.nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);	
		}
		
		private function visitTerms(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.bcs.com"), "_blank");
		}
		
		private function save(event:MouseEvent):void
		{
			profileSaveSignal.dispatch();
		}
		
		private function load(event:MouseEvent):void 
		{
			profileLoadSignal.dispatch();
		}
		
		private function nextScreen(event:MouseEvent):void
		{
			commitProfile();
			nextScreenSignal.dispatch("profile");
		}
		
		
		private function loadPersonalDetails(event:Event = null):void {
			ps.addEventListener(PersonalisationFileStore.DATAREADY, showPersonalData, false, 0, true);
			ps.load();
		}
		
		private function savePersonalDetails():void {
			setPersonalDetails();
			ps.save();
		}
		
		//
		// populate the form with variable list data
		//
		private function showPersonalData(event:Event=null):void {
			var pvars:VariableList = ps.variableList;
			var dob:Date = pvars.dateOfBirth.value as Date;

			//trace("profile:showing dob=",dob);
			profile.yyyyStep.value = dob.fullYear; //.toString();
			profile.mmStep.value = (dob.month + 1);
			profile.ddStep.value = dob.date;
			profile.gender.selectedValue = pvars.gender.toString();

			var dodiagnosis:Date = pvars.dateOfDiagnosis.value as Date;

			//trace("profile:showing dob=",dob);
			profile.diagnosisYyyyStep.value = dodiagnosis.fullYear; //.toString();
			profile.diagnosisMmStep.value = (dodiagnosis.month + 1);
			//profile.diagnosisDdStep.value = 15; //dodiagnosis.date;
			
			// extra Q parameters
			profile.ethnicGroup.selectedIndex = Number(pvars.ethnicGroup);
			profile.height_mStep.value = pvars.height_m.value;
			profile.weight_kgStep.value = pvars.weight_kg.value;
			profile.active.selected = pvars.active.value;
			profile.af.selected = pvars.atrialFibrillation.value;
			
			profile.smokerGroup.selectedIndex = Number(pvars.smokerAtDiagnosis.value);
			
			//profile.diabetic.selected = pvars.diabetic.value;
			
			hba1c_as_percent = Number(pvars.hba1c.value);
			hdlCholesterol_mmol_L = Number(pvars.hdlCholesterol_mmol_L.value);
			totalCholesterol_mmol_L = Number(pvars.totalCholesterol_mmol_L.value);
			
			var nonHDL:Number = totalCholesterol - hdlCholesterol;
			profile.nonHDLField.text = "NonHDL Cholesterol: " + nonHDL.toPrecision(3);	
			profile.LDLField.text = "LDL Cholesterol: " + userProfile.calc_ldl(totalCholesterol, hdlCholesterol).toPrecision(3);
			profile.lipidRatioField.text = "Lipid Ratio: " + userProfile.lipidRatio.toPrecision(3);
			
			profile.systolicBloodPressure = Number(pvars.systolicBloodPressure);
			//profile.SBPTreated.selected = pvars.SBPTreated.value;
						
			validate();
			
		}
		
		//
		// glean a variable list from the form data
		//
		private function setPersonalDetails():void {
			var pvars:VariableList = ps.variableList;
			var s:String = [profile.ddStep.value.toString(), profile.mmStep.value.toString(), profile.yyyyStep.value.toString()].join(":");
			//trace("profile: setting dob=", s);
			pvars.dateOfBirth.fromString(s);
			
			s = ["15", profile.diagnosisMmStep.value.toString(), profile.diagnosisYyyyStep.value.toString()].join(":");
			pvars.dateOfDiagnosis.fromString(s);
			
			pvars.gender.fromString(profile.gender.selectedValue as String);
			
			// extra Q parameters
			pvars.ethnicGroup.value = profile.ethnicGroup.selectedIndex;
			pvars.height_m.value = profile.height_mStep.value;
			pvars.weight_kg.value = profile.weight_kgStep.value;
			pvars.active.value = profile.active.selected;
			pvars.atrialFibrillation.value = profile.af.selected;
			pvars.smokerAtDiagnosis.value = profile.smokerGroup.selectedIndex;
			
			//pvars.diabetic.value = profile.diabetic.selected
			pvars.hba1c.value = hba1c_as_percent;
			pvars.hdlCholesterol_mmol_L.value = hdlCholesterol_mmol_L;
			pvars.totalCholesterol_mmol_L.value = totalCholesterol_mmol_L;
			pvars.systolicBloodPressure.value = profile.systolicBloodPressure;
			//pvars.SBPTreated.value = profile.SBPTreated.selected;
			
			userProfile.isValid = false;
		}
		
		//
		//---- View click events ----
		// 		
		private function commitProfile():void {
			//trace("commitProfile");

			// Set the user profile variableList BEFORE cloning it into the interventions profile
			setPersonalDetails();
			userProfile.resetInterventions();
			
		}
		
		/*------- load from URL ----------*/
		public var configURL:String;
		
		private var loader:URLLoader;
		
		public function loadFromURL():void
		{
			// Acquire configURL from flashVar "config" 
			configURL = FlexGlobals.topLevelApplication.parameters.config;
			if(!configURL || configURL.match(/^\s*$/)) {
				showPersonalData(null);
				return;
			}
			
			//Alert.show("configURL = "+configURL);
			
			var request:URLRequest = new URLRequest(configURL);
			if(!loader) {
				loader = new URLLoader(request);
				addLoaderListeners();
			}
			try {
				loader.load(request);
			}
			catch(e:Error) {
				Alert.show(e.message, "Error opening "+configURL, Alert.OK);
			}
		}
		
		private function readLoader(event:Event):void
		{
			//trace(loader.data);
			var pvars:VariableList = ps.variableList;
			pvars.readXML(new XML(loader.data));
			showPersonalData();
		}
		
		private function addLoaderListeners():void {
			loader.addEventListener(Event.COMPLETE, readLoader, false, 0, true);
			loader.addEventListener(Event.OPEN, openHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		}
		
		private function openHandler(event:Event):void {
			Alert.show(event.toString(), "Open");
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Alert.show(event.toString(), "Network error");
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			Alert.show(event.toString(),"HTTP error");
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Alert.show(event.toString(),"Network error");
		}
		
		public function validate(event:Event = null):void {
			// we don't want lazy validation here!
			
			profile.bmiField.text = "BMI: " + bmi_uncommitted.toPrecision(3);
			
			var nonHDL:Number = totalCholesterol - hdlCholesterol;		
			profile.nonHDLField.text = "NonHDL Cholesterol: " + nonHDL.toPrecision(3);			
			profile.LDLField.text = "LDL Cholesterol: " + userProfile.calc_ldl(totalCholesterol, hdlCholesterol).toPrecision(3);
			profile.lipidRatioField.text = "Lipid Ratio: " + userProfile.lipidRatio.toPrecision(3);
			
			var e1:Boolean = (profile.hdlCholValidator.validate().results != null);
			var e2:Boolean = (profile.totalCholValidator.validate().results != null);
			
//			e1 = (profile.totalCholesterolStep.cholRatio < 1);
//			e2 = (profile.totalCholesterolStep.cholRatio > 12);
			
			var e3:Boolean = (profile.dateValidator.validate().results != null);
			var e4:Boolean = (profile.sbpValidator.validate().results != null);
			var e5:Boolean = (profile.heightValidator.validate().results != null);
			var e6:Boolean = (profile.weightValidator.validate().results != null);
			var e7:Boolean = (profile.hba1cValidator.validate().results != null);
			var e8:Boolean = (profile.diagnosisDateValidator.validate().results != null);
//			var e7:Boolean = (profile.hadCVDValidator.validate().results != null);
//			var e8:Boolean = (profile.termsValidator.validate().results != null);

			if(e1 || e2 || e3 || e4 || e5 || e6 || e7 || e8) {
				isValid = false;
				profile.nextButton.enabled = false;
				profileValidSignal.dispatch(false);
			}
			else {
				isValid = true;
				profile.nextButton.enabled = true;
				profileValidSignal.dispatch(true);
			}
		}
		
		private var isValid:Boolean = false;
		
		public function get totalCholesterol():Number
		{
			return profile.totalCholesterolStep.value;
		}
		public function set totalCholesterol(value:Number):void
		{
			profile.totalCholesterolStep.value = value;
		}
		
		public function get hdlCholesterol():Number
		{
			return profile.hdlCholesterolStep.value;
		}
		public function set hdlCholesterol(value:Number):void
		{
			profile.hdlCholesterolStep.value = value;
		}
		

		private function currentYear():int 
		{
			var d:Date = new Date();
			return d.fullYear;
		}
		
		
		private const cholConversionFactor:Number = 38.7;
		private var mmol_L:String = "mmol/L";
		private var mg_dL:String = "mg/dL";
				
		public function get cholesterolUnit():String
		{
			if(profile.cholUnits.selectedIndex < 0) {
				profile.cholUnits.selectedIndex = 0;
			}
			return profile.cholUnits.selectedItem.unit;
		}
	
		public function get totalCholesterol_mmol_L():Number
		{
			if(cholesterolUnit == mmol_L)
				return totalCholesterol;
			else
				return totalCholesterol / cholConversionFactor;
		}
		public function set totalCholesterol_mmol_L(value:Number):void
		{
			if(cholesterolUnit == mmol_L)
				totalCholesterol = value;
			else
				totalCholesterol = value * cholConversionFactor;
			
		}
		
		public function get hdlCholesterol_mmol_L():Number
		{
			if(cholesterolUnit == mmol_L)
				return hdlCholesterol;
			else
				return hdlCholesterol / cholConversionFactor;
		}
		public function set hdlCholesterol_mmol_L(value:Number):void
		{
			if(cholesterolUnit == mmol_L)
				hdlCholesterol = value;
			else
				hdlCholesterol = value * cholConversionFactor;
		}
		
		
		private var cholUnitFactors:ArrayCollection = new ArrayCollection([
			{unit:"mmol/L", factor: 1},
			{unit:"mg/dL", factor: 1 / cholConversionFactor},
		]);
		

		// Get internal hba1c from display
		public function get hba1c_as_percent():Number
		{
			if(appState.hbA1c_Percent)
				return profile.hba1cStepper.value;
			else
				return UserModel.calc_hba1c_mmol_to_percent(profile.hba1cStepper.value);
		}
		public function set hba1c_as_percent(percent:Number):void
		{
			if(appState.hbA1c_Percent) {
				profile.hba1cStepper.value = percent;
			}
			else {
				profile.hba1cStepper.value = UserModel.calc_hba1c_percent_to_mmol(percent);
			}
		}
		
		private var hba1cUnits:ArrayCollection = new ArrayCollection([
			{unit:"%"},
			{unit:"mmol/mol"},
		]);
		
		
		// TODO: Worry about minimum and maximum ranges and value conversions
		private function change_hba1c_units(event:Event):void 
		{
			appState.hbA1c_Percent = (profile.hbA1cUnits.selectedIndex == 0);
			var stepper:NumericStepper = profile.hba1cStepper;
			
			var oldValue:Number = profile.hba1cStepper.value;
			var newValue:Number = appState.hbA1c_Percent ?
				UserModel.calc_hba1c_mmol_to_percent(oldValue) :
				UserModel.calc_hba1c_percent_to_mmol(oldValue);
			
			stepper.minimum = 0;
			stepper.maximum = 10000;

			stepper.stepSize = appState.hbA1c_Percent ? 0.1 : 1;
			stepper.validateNow();
			
			profile.hba1cValidator.minValue = stepper.minimum = 
				appState.hbA1c_Percent ? 5 : Math.floor(UserModel.calc_hba1c_percent_to_mmol(5));
			
			profile.hba1cValidator.maxValue = stepper.maximum = 
				appState.hbA1c_Percent ? 11 : Math.ceil(UserModel.calc_hba1c_percent_to_mmol(11));
			
			stepper.value = newValue;
			
			stepper.validateNow();
			
			//trace("stepperVal:", stepper.value, "oldValue:",oldValue,"newValue:",newValue, "range:",profile.hba1cStepper.minimum, profile.hba1cStepper.maximum); 
			validate();
		}
		
		private function changedUnits(event:Event):void
		{
			appState.mmol = (cholesterolUnit == mmol_L);

			// be careful to ensure stepper minimum < value < maximum at all times
			var f:Number;
			if(appState.mmol) {
				// valid range is 0.1..20
				f = 1/cholConversionFactor;
			}
			else {
				// valid range is 0.1..20*cholConversionFactor
				f = cholConversionFactor;
			}
			
			updateCholesterolStepper(profile.totalCholesterolStep, profile.totalCholValidator, f);
			updateCholesterolStepper(profile.hdlCholesterolStep, profile.hdlCholValidator, f);
		
			
			validate();
		}
		
		private function updateCholesterolStepper(stepper:NumericStepper, validator:Validator, f:Number):void {

			var newMin:Number = 0.000001;	
			var newMax:Number = stepper.maximum * f;
			var newVal:Number = stepper.value * f;
			
			stepper.maximum = Math.max(newMax, stepper.maximum);
			stepper.stepSize = 0.1;
			stepper.valueParseFunction = function(s:String):Number {
				return Number(s); //Math.round(Number(s)*100000)/100000;
			}
			stepper.valueFormatFunction = function(val:Number):String 
			{
				return val.toFixed(1);
			};
			
			stepper.value = newVal;

			if(f > 1) {
				stepper.stepSize = 1;
				newMin = 1;
				stepper.value = Math.round(newVal);
				stepper.valueParseFunction = function(s:String):Number {
					return parseInt(s);
				}
				stepper.valueFormatFunction = function(val:Number):String 
				{
					return val.toFixed(0);
				};
			}

			stepper.minimum = newMin;
			stepper.maximum = newMax;

			stepper.validateNow();
		}
		
		private var _metres:Number = 1.75;
		public function get metres():Number
		{
			return _metres;
		}
		public function set metres(m:Number):void
		{
			_metres = m;
		}
		
		public var kg:Number = 1.75;
		//public var bmi:Number = 1;
		
		
		private var feet:Number = 5;
		
		public var inches:Number = 10;
		public var stones:Number = 10;
		public var pounds:Number = 0;
		public var lbs:Number = 150;
				
		public function get bmi():Number
		{
			var pvars:VariableList = ps.variableList;
			var m:Number = Number(pvars.height_m);
			var kg:Number = Number(pvars.weight_kg);
			return kg/(m*m);
		}
		
		public function get bmi_uncommitted():Number
		{
			var m:Number = Number(profile.height_mStep.value);
			var kg:Number = Number(profile.weight_kgStep.value);
			return kg/(m*m);
		}

	}
}