/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import org.understandinguncertainty.UKPDS.model.vo.ParamsVO;

	public class UKPDSParameters 
	{

		private var chd:ParamsVO;
		private var stroke:ParamsVO;
		private var noncv:ParamsVO;


		function UKPDSParameters()
		{
			chd = new ParamsVO();
			chd.intercept 					= 0.0112;
			chd.diabetesDuration 			= 1.078;
			chd.age 						= 1.059;
			chd.female						= 0.525; 
			chd.afroCarib					= 0.390;
			chd.smoker						= 1.35;
			chd.hba1c						= 1.183;
			chd.systolicBloodPressure		= 1.088;
			chd.lipidRatio 					= 3.845;
			chd.atrialFibrilation			= Number.NaN;
			
			chd.int_hba1c					= 1.183431953;
			chd.int_stop_smoking_man		= 0.518394649;
			chd.int_stop_smoking_woman		= 0.483709273;
			chd.int_ldl_cholesterol			= 1.265822785;
			chd.int_lose_weight				= 0.776;
			chd.int_become_active			= 0.57;
			chd.int_ace_arb					= 0.92;

			stroke = new ParamsVO();
			stroke.intercept 				= 0.00186;
			stroke.diabetesDuration 		= 1.145;
			stroke.age 						= 1.145;
			stroke.female					= 0.7; 
			stroke.afroCarib				= Number.NaN;
			stroke.smoker					= 1.547;
			stroke.hba1c					= Number.NaN;
			stroke.systolicBloodPressure	= 1.122;
			stroke.lipidRatio 				= 1.138;
			stroke.atrialFibrilation		= 8.554;	
			
			stroke.int_stop_smoking_man		= 0.518394649;
			stroke.int_stop_smoking_woman	= 0.483709273;
			stroke.int_ldl_cholesterol		= 1.265822785;
			stroke.int_lose_weight			= 0.776;
			stroke.int_become_active		= 0.57;
			stroke.int_ace_arb				= 0.92;
			stroke.int_sbp					= 1.059695762
				
			noncv = new ParamsVO();
			noncv.int_stop_smoking_man		= 0.53256705;
			noncv.int_stop_smoking_woman	= 0.658634538;

		}

		public function chd_q1(
			age:Number,
			gender:String,
			afroCarib:Boolean,
			smoker:Boolean,
			hba1c:Number,
			systolicBloodPressure:Number,
			lipidRatio:Number
			):Number {
			
			return 
				chd.intercept
					* Math.pow(chd.age, age-55)
					* (gender == "male" ? 1 : chd.female)
					* (afroCarib ? chd.afroCarib : 1)
					* (smoker ? chd.smoker : 1)
					* Math.pow(chd.hba1c, hba1c-6.72)
					* Math.pow(chd.systolicBloodPressure, (systolicBloodPressure-135.7)/10)
					* Math.pow(chd.lipidRatio, Math.ln(lipidRatio)-1.59);
		}
		
		// chd intervention hazard
		public function chd_int(
			q1:Number, // input result of chd_q1 calculation above
			
			
								
		
	}
}
