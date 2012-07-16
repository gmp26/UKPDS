/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.variables.DateOfBirth;
	
	[ResourceBundle("UKPDS")]
	public class UserModel 
	{
		[Inject]
		public var resourceManager:IResourceManager;		
		
		public var personalData:PersonalisationFileStore;
		
		public var variableList:VariableList;
		
		[Bindable]
		public var isValid:Boolean = true;

		public function UserModel()
		{
			variableList = new VariableList();
			personalData = new PersonalisationFileStore(variableList);

			super();
		}
		
		public var hba1c_int:Number;
		public var sbp_int:Number;
		public var totalCholesterol_int:Number;
		public var hdlCholesterol_int:Number;
		public var smoker_int:Boolean;
		public var overweight_int:Boolean;
		public var active_int:Boolean;
		
		// reset interventions to zero - i.e. no change from Profile values
		public function resetInterventions():void {
			hba1c_int = Number(variableList.hba1c.value);
			sbp_int = Number(variableList.systolicBloodPressure.value);
			totalCholesterol_int = Number(variableList.totalCholesterol_mmol_L.value);
			hdlCholesterol_int = Number(variableList.hdlCholesterol_mmol_L.value);
			smoker_int = Boolean(variableList.smokerAtDiagnosis.value);
			overweight_int = overweight;
			active_int = Boolean(variableList.active.value);
			
			_nonZeroInterventions = false;
		} 
		
		private var _nonZeroInterventions:Boolean = false;
		public function get nonZeroInterventions():Boolean {
			return _nonZeroInterventions;
		}
		
		public function get chdHazardForInterventions():Number {
			
			var ratio:Number = 1;

			// HbA1c
			var r:Number = Math.pow(0.845,100*(hba1c - hba1c_int)/hba1c);
			ratio *= r;

			// LDL
			r = Math.pow(0.79, 
				calc_ldl(totalCholesterol, hdlCholesterol) - calc_ldl(totalCholesterol_int, hdlCholesterol_int));
			ratio *= r;
			
			// Smoking
			if(smokerAtDiagnosis != smoker_int) {
				if(isMale) {
					r = smoker_int ? 1/0.52 : 0.52;
				}
				else {
					r = smoker_int ? 1/0.48 : 0.48;
				}
				ratio *= r;
			}
			
			// Weight Loss
			/*
			var before:Number = calc_bmi(weight_kg, height_m);
			var after:Number = calc_bmi(weight_kg_int, height_m);
			r = isMale ? 
				boundaryHazard(before, after, 30.4, 0.776) :
				boundaryHazard(before, after, 32.6, 0.776);
			*/
			
			r = 1;
			if(overweight != overweight_int) {
				r = overweight ? 0.776 : 1/0.776;
			}
			ratio *= r;
			
			// Activity
			// Active for more than 4 hours per week
			r = active ? 
				(active_int ? 1 : 1/0.57) :
				(active_int ? 0.57 : 1);
			ratio *= r;
			
			if(ratio != 1) {
				_nonZeroInterventions = true;;
			}
			
			return ratio;
		}

		public function get strokeHazardForInterventions():Number {
			
			var ratio:Number = 1;

			// sbp
			var r:Number = Math.pow(0.56, (sbp - sbp_int)/10);
			ratio *= r;

			// LDL
			r = Math.pow(0.79, 
				calc_ldl(totalCholesterol, hdlCholesterol) - calc_ldl(totalCholesterol_int, hdlCholesterol_int));
			ratio *= r;
			
			// Smoking
			if(smokerAtDiagnosis != smoker_int) {
				if(isMale) {
					r = smoker_int ? 1/0.52 : 0.52;
				}
				else {
					r = smoker_int ? 1/0.48 : 0.48;
				}
				ratio *= r;
			}
			
			// Weight Loss
			/*
			var before:Number = calc_bmi(weight_kg, height_m);
			var after:Number = calc_bmi(weight_kg_int, height_m);
			r = isMale ? 
				boundaryHazard(before, after, 30.4, 0.776) :
				boundaryHazard(before, after, 32.6, 0.776);
			ratio *= r;
			*/
			r = 1;
			if(overweight != overweight_int) {
				r = overweight ? 0.776 : 1/0.776;
			}
			ratio *= r;
			
			// Active for more than 4 hours per week
			r = active ? 
				(active_int ? 1 : 1/0.57) :
				(active_int ? 0.57 : 1);
			ratio *= r;
			
			if(ratio != 1) {
				_nonZeroInterventions = true;
			}
			
			return ratio;
		}
		
		public function get nonCVDHazardForInterventions():Number {
			
			var r:Number = 1;

			// Smoking
			if(smokerAtDiagnosis != smoker_int) {
				if(isMale) {
					r = smoker_int ? 1/0.53 : 0.53;
				}
				else {
					r = smoker_int ? 1/0.66 : 0.66;
				}
			}
						
			if(r != 1) {
				_nonZeroInterventions = true;;
			}
			
			return r;
		}
				

		private function boundaryHazard(before:Number, after:Number, threshold:Number, droppingRatio:Number):Number {
			if (before >= threshold && after < threshold) {
				return droppingRatio;
			}
			else if (before <= threshold && after > threshold) {
				return 1/droppingRatio;
			}
			return 1;
		}
		
		public function calc_ldl(total:Number, hdl:Number):Number {
			return (total - hdl)/1.24;
		}
		
		// User Variables
		public function get age():int
		{
			var dob:Number = variableList.dateOfBirth.getDuration();
			if(dob == 0 || isNaN(dob))
				trace("weird age seen:", dob);
			
			return dob;
		}
		
		// User Variables
		public function get ageAtDiagnosis():Number
		{
			var d:Number = variableList.dateOfDiagnosis.subtract(variableList.dateOfBirth)/DateOfBirth.msInYear;
			/*
			var d:Number = variableList.dateOfBirth.getDuration();
			*/
			if(d == 0 || isNaN(d))
				trace("weird ageAtDiagnosis seen:", d);
			return d;
		}
		
		public function get gender():String
		{
			return variableList.gender.toString();
		}
		
		// in years
		public function get diabetesDuration():Number {
			return variableList.dateOfDiagnosis.getDuration();
		}
		
		public function get isMale():Boolean {
			return variableList.gender.toString() == "male";
		}
		
		public function get isFemale():Boolean {
			return variableList.gender.toString() != "male";
		}
			
		public function get bmi():Number
		{
			return calc_bmi(variableList.weight_kg.value, variableList.height_m.value);
		}
		/*
		public function get bmi_int():Number
		{
			return calc_bmi(weight_kg_int, variableList.height_m.value);
		}
		*/
		public function get weightLimit():Number {
			return (isMale ? 30.4 : 32.6) * height_m * height_m;
		}
		
		public function get overweight():Boolean {
			return weight_kg > weightLimit;
		}
		
		public function get afroCarib():Boolean
		{
			// See locale/en_US/UKPDS.properties ethnicity.x
			return Number(variableList.ethnicGroup.value) == 6;  // Black Caribbean
		}
		
		public function get hba1c():Number {
			return variableList.hba1c.value;
		}
		
		public function get sbp():Number
		{
			return Number(variableList.systolicBloodPressure.value);	
		}
		
		public function get smokerAtDiagnosis():Boolean {
			return Number(variableList.smokerAtDiagnosis.value) == 1;
		}
		
		public function get lipidRatio():Number {
			return calc_lipidRatio(totalCholesterol, hdlCholesterol);
		}
		
		public function get atrialFibrillation():Boolean {
			return variableList.atrialFibrillation.value;
		}
		
		public function get smoke_cat():int
		{
// TODO			return Number(variableList.smokerGroup.value);
			return 1;
		}

		public function get totalCholesterol():Number
		{
			return Number(variableList.totalCholesterol_mmol_L.value);	
		}

		public function get hdlCholesterol():Number
		{
			return Number(variableList.hdlCholesterol_mmol_L.value);	
		}
		
		public function get active():Boolean {
			return variableList.active.value;
		}
		
		public function boolInt(b:Boolean):int
		{
			return b ? 1 : 0;
		}
		
		public function get weight_kg():Number {
			return 	variableList.weight_kg.value;
		}
		
		public function get height_m():Number {
			return variableList.height_m.value;
		}
		
		/* Read only accessor for ethnic groups defined in locale/UKPDS.properties */
		private var _ethnicGroups:Vector.<String>;		
		public function get ethnicGroups():Vector.<String> {
			if(_ethnicGroups == null) {
				var keyPrefix:String = "ethnicity.";
				_ethnicGroups = new Vector.<String>();
				var g:String;
				for(var i:int=0; (g = resourceManager.getString("UKPDS", keyPrefix+i)) != null; i++) {
					_ethnicGroups[i] = g;
				}
			}
			return _ethnicGroups;
		}
		

		
		// Unit Conversions
		
		/* Some derived variables */
		public static function calc_lipidRatio(total:Number, hdl:Number):Number
		{
			return total/hdl;
		}
		
		public static function calc_ldl(total:Number, hdl:Number):Number {
			return (total - hdl)/1.24;
		}
		
		public static function calc_bmi(weight:Number, height:Number):Number
		{
			return weight/(height*height);
		}
		
		public static function metres_to_feet(metres:Number):Number
		{
			return Math.floor(metres * 3.2808399 + 1/24);
		}
		
		public static function inches(metres:Number):Number
		{
			return Math.round(metres * 3.2808399 + 1/24 - metres_to_feet(metres)*12);
		}
		
		public static function stones(kilos:Number):Number
		{
			return Math.floor(kilos * 0.157473044 + 1/28);			
		}
		
		public function pounds(kilos:Number):Number
		{
			return Math.round(kilos * 0.157473044 + 1/28 - stones(kilos)*14);						
		}
		
		public function lbs(kilos:Number):Number
		{
			return Math.round(Number(kilos) * 2.20462262);
		}
		
		public function percent_to_DCCT_hba1c(percent:Number):Number {
			return (percent - 2.15)*10.929;
		}

		public function DCCT_hba1c_to_percent(DCCT:Number):Number {
			return DCCT/10.929 + 2.15;
		}
	}
}