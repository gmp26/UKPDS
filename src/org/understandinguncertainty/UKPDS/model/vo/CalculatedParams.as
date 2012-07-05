/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	public class CalculatedParams {
		public var a:Number;
		public var a_int:Number;
		public var b:Number;
		public var b_int:Number;
		public var genPop_a:Number
		public var genPop_b:Number
		
		function CalculatedParams(a:Number, a_int:Number, 
								  b:Number, b_int:Number, 
								  genPop_a:Number, genPop_b:Number)
		{
			this.a = a;
			this.a_int = a_int;
			this.genPop_a = genPop_a;
			trace("a=", a," a_int=", a_int, 
				" b=", b," b_int=", b_int, 
				" genPop_a=", genPop_a);
		}
	}
}