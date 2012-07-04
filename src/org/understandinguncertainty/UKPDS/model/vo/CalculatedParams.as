/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	public class CalculatedParams {
		public var a:Number;
		public var a_int:Number;
		public var genPop_a:Number
		public var h:Number;
		
		function CalculatedParams(a:Number, a_int:Number, h:Number, genPop_a:Number)
		{
			this.a = a;
			this.a_int = a_int;
			this.h = h;
			this.genPop_a = genPop_a;
			trace("a=", a," a_int=", a_int," h=", h, " genPop_a=", genPop_a);
		}
	}
}