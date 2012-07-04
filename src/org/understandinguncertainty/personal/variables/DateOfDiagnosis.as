/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.variables
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.DDMMYYYY_PersonalVariable;
	
	public class DateOfDiagnosis extends DDMMYYYY_PersonalVariable implements IPersonalVariable
	{
				
		function DateOfDiagnosis(instanceName:String, date:Date) {
			super(instanceName, date);
		}

		override public function get value():* {
			if(_value == null) {
				_value = new Date();
			}
			return _value;
		}
		override public function set value(v:*):void {
			super.value = v;
		}
		
		public function getDuration():int {
			var date:Date = value;
			if(date == null) return -1;
			var now:Date = new Date();

			var yearDiff:int = now.getFullYear() - date.getFullYear();
			var monthDiff:int = now.getMonth() - date.getMonth();

			if(monthDiff > 0)
				return yearDiff;
			
			if(monthDiff < 0)
				return yearDiff-1;
			
			var dayDiff:int = now.date - date.date;
			if(dayDiff >= 0)
				return yearDiff;
			else
				return yearDiff - 1;

		}

	}
}