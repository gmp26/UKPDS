/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.interfaces
{
	
	
	public interface IPersonalVariable
	{
		function get name():String;
		function get symbol():String;
		function set symbol(s:String):void;

		function get value():*;
		function set value(v:*):void;

		function fromString(s:String):void;
		function toString():String;
		
		function get type():String;
		
	}
}