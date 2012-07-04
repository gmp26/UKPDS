/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import flash.utils.getQualifiedClassName;
	
	public class GenericPersonalVariable
	{		
		private var _name:String;
				
		function GenericPersonalVariable(instanceName:String, defaultValue:*) {
			_name = instanceName;
			_value = defaultValue;
		}
		
		public function get name():String {
			return _name;
		}

		protected var _value:*;
		public function get value():* {
			return _value;
		}
		public function set value(v:*):void {
			_value = v;
		}

	}
}