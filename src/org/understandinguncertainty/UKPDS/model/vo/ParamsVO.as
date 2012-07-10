/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	public class ParamsVO
	{
		// UKPDS
		public var intercept:Number; 
		public var age:Number;
		public var female:Number;
		public var diabetesDuration:Number;
		public var lipidRatio:Number;
		public var afroCarib:Number;
		public var smoker:Number;
		public var hba1c:Number;
		public var systolicBloodPressure:Number;
		public var atrialFibrillation:Number;
		
		// UKPDS interventions
		public var int_hba1c:Number;
		public var int_stop_smoking_man:Number;
		public var int_stop_smoking_woman:Number;
		public var int_ldl_cholesterol:Number;
		public var int_lose_weight:Number;
		public var int_become_active:Number;
		public var int_ace_arb:Number;
		public var int_sbp:Number;	
		
	}
}