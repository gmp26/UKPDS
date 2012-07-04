/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;

	public class NumberPersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		function NumberPersonalVariable(instanceName:String, defaultValue:*) {
			super(instanceName, defaultValue);
		}
		
/*
		override public function get value():* {
			return _value;
		}
		override public function set value(v:*):void {
			_value = v;
		}
*/
		
		public function fromString(s:String):void {
			value = Number(s);
		}
		
		public function toString():String {
			return !isNaN(value) ? value.toString() : "";
		}

		public function get type():String
		{
			return "Number";	
		}
	}
}