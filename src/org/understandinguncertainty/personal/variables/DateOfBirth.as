/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.variables
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.types.DDMMYYYY_PersonalVariable;
	
	public class DateOfBirth extends DDMMYYYY_PersonalVariable implements IPersonalVariable
	{
				
		function DateOfBirth(instanceName:String, date:Date) {
			super(instanceName, "dob", date);
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
		
		public function getAge():int {
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
		
		public static const msInYear:Number = 1000*60*60*24*365.25;

		public function getDuration():Number {
			var date:Date = value;
			if(date == null) return -1;
			var now:Date = new Date();
			
			var elapsedMilliSecs:Number = now.time - date.time;
			return elapsedMilliSecs/msInYear;
		}
	}
}