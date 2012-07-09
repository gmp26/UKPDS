/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
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
		public var smoker_int:Boolean;
		public var sbp_int:Number;
		public var totalCholesterol_int:Number;
		public var hdlCholesterol_int:Number;
		public var weight_kg_int:Number;
		public var minsActivityPerWeek_int:Number;
		
		public function get ldl():Number {
			return (totalCholesterol - hdlCholesterol)/1.24;
		}
		
		public function get active():Boolean {
			return minsActivityPerWeek_int >= 240;
		}
		
		public function get weightLoss():Boolean {
			var old_bmi:Number = calc_bmi(weight_kg, height_m);
			var new_bmi:Number = calc_bmi(weight_kg_int, height_m);
			if(isMale) {
				return old_bmi > 30.4 && new_bmi < 30.4;
			}
			else {
				return old_bmi > 32.6 
			}
		}
		
		
		// User Variables
		public function get age():int 
		{
			var dob:int = variableList.dateOfBirth.getAge();
			if(dob == 0 || isNaN(dob))
				trace("weird age seen:", dob);
			
			return dob;
		}
		
		public function get gender():String
		{
			return variableList.gender.toString();
		}
		
		
		public function get diabetesDuration():Number {
			return variableList.dateOfDiagnosis.getDuration();
		}
		
		public function get isMale():Boolean {
			return variableList.gender.toString() == "male";
		}
		
		public function get isFemale():Boolean {
			return variableList.gender.toString() != "male";
		}
		
		public function get atrialFibrilation():int
		{
			return boolInt(variableList.atrialFibrillation.value);
		}
		
		public function get bmi():Number
		{
			return variableList.bmi;
		}
		
		public function get afroCarib():Boolean
		{
			// TODO: tie this in
			return Number(variableList.ethnicGroup.value) == 6;
		}
		
		public function get rati():Number
		{
			var total:Number = Number(variableList.totalCholesterol_mmol_L.value);
			var hdl:Number = Number(variableList.hdlCholesterol_mmol_L.value);
			return total/hdl;
		}
		
		public function get sbp():Number
		{
			return Number(variableList.systolicBloodPressure.value);	
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