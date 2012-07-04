/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.variables.DateOfBirth;
	import org.understandinguncertainty.personal.variables.YearOfBirth;
	
	public class AgePersonalVariable extends NumberPersonalVariable implements IPersonalVariable
	{
		public function AgePersonalVariable(instanceName:String, defaultValue:*)
		{
			super(instanceName, defaultValue);
		}

		// injected
		public var yearOfBirth:YearOfBirth;
		public var dateOfBirth:DateOfBirth;
		
		override public function get value():* {
			if(dateOfBirth != null)
				return dateOfBirth.getAge();
			if(yearOfBirth != null)
				return yearOfBirth.getAge();
			return _value;
		}
		override public function set value(v:*):void {
			if(yearOfBirth != null) {
				var date:Date = new Date();
				yearOfBirth.value = date.fullYear - v;
				_value = yearOfBirth.getAge();
			}
			else
				_value = v;
		}
		
	}
}