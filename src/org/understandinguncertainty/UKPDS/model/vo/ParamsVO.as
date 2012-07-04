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
		public var atrialFibrilation:Number;
		
		// UKPDS interventions
		public var int_hba1c:Number;
		public var int_stop_smoking_man:Number;
		public var int_stop_smoking_woman:Number;
		public var int_ldl_cholesterol:Number;
		public var int_lose_weight:Number;
		public var int_become_active:Number;
		public var int_ace_arb:Number;
		public var int_sbp:Number;
		
		/*
		// framingham
		public var age:Number;
		public var totalCholesterol_mmol_L:Number;
		public var hdlCholesterol_mmol_L:Number;
		public var systolicBloodPressure:Number;		
		public var SBPTreated:Number;
		public var smoker:Number;
		public var diabetic:Number;
		
		// qrisk betas
		public var age_1:Number;
		public var age_2:Number;
		public var bmi_1:Number;
		public var rati:Number;
		public var sbp:Number;
		public var town:Number;
		public var b_AF:Number;
		public var b_ra:Number;
		public var b_renal:Number;
		public var b_treatedhyp:Number;
		public var b_type2:Number;
		public var fh_cvd:Number;
		public var smok:Number;
		*/
	}
}