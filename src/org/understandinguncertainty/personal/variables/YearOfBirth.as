/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.variables
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.NumberPersonalVariable;
	
	public class YearOfBirth extends NumberPersonalVariable implements IPersonalVariable
	{

		public var dateOfBirth:DateOfBirth;
		
		override public function set value(v:*):void {
			super.value = v;
			dateOfBirth.value.fullYear = v;
		}
		
		function YearOfBirth(instanceName:String, defaultValue:*) {
			super(instanceName, defaultValue);
		}
		
		public function getAge():int {
			var yob:Number = value;
			if(isNaN(yob)) return -1;
			var now:Date = new Date();
			var age:Number = now.getFullYear() - yob;
			return age;
		}

	}
}