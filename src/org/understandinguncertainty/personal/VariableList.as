/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal
{
	import flash.utils.describeType;
	
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;
	import org.understandinguncertainty.personal.types.DDMMYYYY_PersonalVariable;
	import org.understandinguncertainty.personal.types.NumberPersonalVariable;
	import org.understandinguncertainty.personal.types.StringPersonalVariable;
	import org.understandinguncertainty.personal.variables.*;
	
	/**
	 * The VariableList defines all variables that we might be interested in. You should never
	 * delete a variable from this list even if you don't need it since other animations or plugins
	 * may require it, and it is ONLY variables in this list that are ever saved to personal files.
	 *   
	 * @author gmp26
	 * 
	 */
	public class VariableList {
		
		public var dateOfBirth:DateOfBirth; 
//		public var age:AgePersonalVariable = new AgePersonalVariable("age", 55);
		public var gender:StringPersonalVariable = new StringPersonalVariable("gender", "male");

/*		public function get afroCaribbean():Boolean {
			return Number(ethnicGroup.value) == 5; // magic number: selects "Black Caribbean" 
			// see profile.dataProvider.ethnicGroup initialisation
		}
*/
		
		public var dateOfDiagnosis:DateOfDiagnosis = new DateOfDiagnosis("dateOfDiagnosis", new Date());
		public var hba1c:NumberPersonalVariable = new NumberPersonalVariable("hba1c", 6.72);
		public var systolicBloodPressure:NumberPersonalVariable = new NumberPersonalVariable("systolicBloodPressure", 135.5);
		public var lipidRatio:NumberPersonalVariable = new NumberPersonalVariable("lipidRatio", 5.11);
		public var atrialFibrillation:BooleanPersonalVariable = new BooleanPersonalVariable("atrialFibrillation", false);
		public var totalCholesterol_mmol_L:NumberPersonalVariable = new NumberPersonalVariable("totalCholesterol_mmol_L", 5.5);
		public var hdlCholesterol_mmol_L:NumberPersonalVariable = new NumberPersonalVariable("hdlCholesterol_mmol_L", 1.16);
		public var ethnicGroup:NumberPersonalVariable = new NumberPersonalVariable("ethnicGroup", 0);
		public var smokerAtDiagnosis:BooleanPersonalVariable = new BooleanPersonalVariable("smokerAtDiagnosis", false);
		public var weight_kg:NumberPersonalVariable = new NumberPersonalVariable("weight_kg", 65);
		public var height_m:NumberPersonalVariable = new NumberPersonalVariable("height_m", 1.7);
		public var minsActivityPerWeek:NumberPersonalVariable = new NumberPersonalVariable("minsActivityPerWeek", 200);
		
		/* following are unused in UKPDS */
		/*
		public var fiveaday:BooleanPersonalVariable = new BooleanPersonalVariable("fiveaday", true);
		public var moderateAlcohol:BooleanPersonalVariable = new BooleanPersonalVariable("moderateAlcohol", true);
		public var smokerGroup:NumberPersonalVariable = new NumberPersonalVariable("smokerGroup", true);
		public var nonSmoker:BooleanPersonalVariable = new BooleanPersonalVariable("nonSmoker", true);
		public var quitSmoker:BooleanPersonalVariable = new BooleanPersonalVariable("quitSmoker", false);		
		public var SBPTreated:BooleanPersonalVariable = new BooleanPersonalVariable("SBPTreated", false);
		public var diabetic:BooleanPersonalVariable = new BooleanPersonalVariable("diabetic", false);
		
		public var chronicRenalDisease:BooleanPersonalVariable = new BooleanPersonalVariable("chronicRenalDisease", false);
		public var rheumatoidArthritis:BooleanPersonalVariable = new BooleanPersonalVariable("rheumatoidArthritis", false);
		public var relativeHadCVD:BooleanPersonalVariable = new BooleanPersonalVariable("relativeHadCVD", false);
		public var postCode:StringPersonalVariable = new StringPersonalVariable("postCode", "");
		
		public var townsend:NumberPersonalVariable = new NumberPersonalVariable("townsend", 0);
		public var townsendGroup:NumberPersonalVariable = new NumberPersonalVariable("townsendGroup", 2);
		*/
				
		function VariableList() {
			
			// set default age to 40 
			var today:Date = new Date();
			var fortyYearsAgo:Date = today;
			fortyYearsAgo.fullYear -= 40;
			var tenYearsAgo:Date = new Date();
			tenYearsAgo.fullYear -= 10;
			dateOfBirth = new DateOfBirth("dateOfBirth", fortyYearsAgo);
			dateOfDiagnosis = new DateOfDiagnosis("dateOfDiagnosis", tenYearsAgo);
		}

		public function toString():String
		{
			var s:String = "age:" + (dateOfBirth.getAge());
			s +=" T:" + (dateOfDiagnosis.getDuration());
			s += " sex:" + (gender.value as String);
			s += " tc:" + (totalCholesterol_mmol_L.value as Number);
			s += " hdl:" + (hdlCholesterol_mmol_L.value as Number);
			s += " sbp:" + (systolicBloodPressure.value as Number) + "\n";
			s += " smok:" + (smokerAtDiagnosis.value as Boolean);
			s += " ethnicGroup:" + (ethnicGroup.value as Number);
			return s;
		}
		
		
		public function getVariable(name:String):IPersonalVariable {
			return this[name] as IPersonalVariable;
		}
		
		
		/**
		 * If this works well, use it in lieu of clone() so we don't get clone errors when we add or delete variables.
		 * 
		 * @return a clone of the VariableList using introspection
		 * 
		 */
		public function clone():VariableList {
			var copy:VariableList = new VariableList();
			var vList:XMLList = describeType(this).variable;
			var len:int = vList.length();
			for(var i:int = 0; i < len; i++) {
				var name:String = vList[i].@name;
				var fromVar:IPersonalVariable = this[name] as IPersonalVariable;
				var toVar:IPersonalVariable = copy[name] as IPersonalVariable;
				toVar.value = fromVar.value;
			}
			return copy;
		}
		
		public function equals(other:VariableList):Boolean {
			var vList:XMLList = describeType(this).variable;
			var len:int = vList.length();
			for(var i:int = 0; i < len; i++) {
				var name:String = vList[i].@name;
				var fromVar:IPersonalVariable = this[name] as IPersonalVariable;
				var toVar:IPersonalVariable = other[name] as IPersonalVariable;
				if(toVar.value != fromVar.value)
					return false;
			}
			return true;
		}
		
		/**
		 * <p>Write the variable list serialised into XML</p> 
		 * @return the XML
		 * 
		 */
		public function writeXML():XML {
			var written:XML = <personalData/>;
			var vList:XMLList = describeType(this).variable;
			for(var i:int = 0; i < vList.length(); i++) {
				var name:String = vList[i].@name;
				var pv:IPersonalVariable = this[name] as IPersonalVariable;
				if(pv == null || pv.value == null) continue;
				var stringValue:String = pv.toString();
				if(stringValue==null) continue;
				var xml:XML = <{name}>{stringValue}</{name}>;
				written.appendChild(xml);
			}
			return written;
		}
		
		/**
		 * Read XML into the variable list 
		 * @param xml the XML to read
		 * 
		 */
		public function readXML(xml:XML):void {
			
			var vList:XMLList = describeType(this).variable;
			for(var i:int = 0; i < vList.length(); i++) {
				var name:String = vList[i].@name;
				var nameValue:XMLList = xml.child(name);
				var pv:IPersonalVariable = this[name] as IPersonalVariable;
				if(pv == null)
					throw new Error("Check " + name, "Unknown Personalisation Variable");
				if(nameValue != null && nameValue.length() == 1)
					pv.fromString(nameValue.toString());
			}
			
		}

	}
}