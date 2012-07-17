/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;

	public class BooleanPersonalVariable extends GenericPersonalVariable implements IPersonalVariable
	{
		
		public function BooleanPersonalVariable(instanceName:String, symbol:String, defaultValue:*) {
			super(instanceName, symbol, defaultValue);
		}

		public function fromString(s:String):void
		{
			value = s.match(/^\s*(t|true)\s*$/i) != null;
		}
		
		public function toString():String
		{
			return value ? "true" : "false";
		}
		
		public function get type():String
		{
			return "Boolean";	
		}
	}
}