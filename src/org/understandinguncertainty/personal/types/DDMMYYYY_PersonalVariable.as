/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	
	public class DDMMYYYY_PersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		
		function DDMMYYYY_PersonalVariable(instanceName:String, date:Date) {
			super(instanceName, date);
		}
		
		override public function get value():* {
//			if(_value.fullYear == 1961  || _value.fullYear == 1960) {
//				trace("DDMM get");
//			}
			return _value;
		}
		
		override public function set value(v:*):void {
//			if(v.fullYear == 1960 || v.fullYear == 1961) {
//				trace("DDMM set: " + v.fullYear);
//			}
			_value = v;
		}
		
		public function fromString(s:String):void {
			if(s) {
				//trace("DDMMYYYY set date from:"+s);
				
				// Assume dd/mm/yyyy format for Date of Birth
				var dmy:Array = s.split(/:|\//);
				var day:int;
				var month:int;
				var year:int;
				
				if(dmy.length == 3) {
					day = parseInt(dmy[0]);
					month = parseInt(dmy[1]);
					year = parseInt(dmy[2]);
				}
				
				if(isNaN(day) || isNaN(month) || isNaN(year))
					throw new Error("invalid date of birth: " + s);
								
				value = new Date(year, month-1, day);
//				trace("DDMMYYYY date set to: "+value + " " + this.toString());
			}
		}
		
		public function toString():String {
			if(value == null) return null;
			return value.date+"/"+(value.month+1)+"/"+value.fullYear;
		}

		public function get type():String
		{
			return "Date";	
		}
		
	}
}