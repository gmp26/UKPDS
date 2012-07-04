/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;

	public class StringPersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{		
		function StringPersonalVariable(instanceName:String, defaultValue:*) {
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
			value = s;
		}
		
		public function toString():String {
			return value;
		}
	
		public function get type():String
		{
			return "String";	
		}
	}
}