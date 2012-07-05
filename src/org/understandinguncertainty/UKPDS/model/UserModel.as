/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	public class UserModel 
	{
		public var variableList:VariableList;
		public var personalData:PersonalisationFileStore;
		
		[Bindable]
		public var isValid:Boolean = true;

		public function UserModel()
		{
			variableList = new VariableList();
			personalData = new PersonalisationFileStore(variableList);

			super();
		}
		
		public function get gender():String
		{
			return variableList.gender.toString();
		}
		
		public function get age():int 
		{
			var dob:int = variableList.dateOfBirth.getAge();
			if(dob == 0 || isNaN(dob))
				trace("weird age seen:", dob);
			
			return dob;
		}
		
		public function get diabetesDuration():Number {
			var t = variableList.dateOfDiagnosis.getDuration();
		}
		
		public function get isMale():Boolean {
			return variableList.gender.toString() == "male";
		}
		
		public function get isFemale():Boolean {
			return variableList.gender.toString() != "male";
		}
		
		public function get gender():int
		{
			return variableList.gender.toString() == "male" ? 1 : 0;
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
			return Number(variableList.ethnicGroup.value) + 1 == ;
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
			return Number(variableList.smokerGroup.value);
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
		
	}
}