/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.types
{
	import flash.utils.getQualifiedClassName;
	
	public class GenericPersonalVariable
	{		
		private var _name:String;
		private var _symbol:String;
				
		function GenericPersonalVariable(instanceName:String, symbol:String, defaultValue:*) {
			_name = instanceName;
			_symbol = symbol;
			_value = defaultValue;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get symbol():String {
			return _symbol;
		}

		public function set symbol(s:String):void {
			_symbol = s;
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