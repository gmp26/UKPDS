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
		private var mean:ParamsVO;

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
			chd.atrialFibrillation			= Number.NaN;
			
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
			stroke.atrialFibrillation		= 8.554;	
			
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
			
			return chd.intercept
					* Math.pow(chd.age, age-55)
					* (gender == "male" ? 1 : chd.female)
					* (afroCarib ? chd.afroCarib : 1)
					* (smoker ? chd.smoker : 1)
					* Math.pow(chd.hba1c, hba1c-6.72)
					* Math.pow(chd.systolicBloodPressure, (systolicBloodPressure-135.7)/10)
					* Math.pow(chd.lipidRatio, Math.log(lipidRatio)-1.59);
		}			
			
		public function stroke_q1(
			age:Number,
			gender:String,
			smoker:Boolean,
			systolicBloodPressure:Number,
			lipidRatio:Number,
			atrialFibrillation:Boolean
			):Number {
			
			return stroke.intercept
					* Math.pow(stroke.age, age-55)
					* (gender == "male" ? 1 : stroke.female)
					* (smoker ? stroke.smoker : 1)
					* Math.pow(stroke.systolicBloodPressure, (systolicBloodPressure-135.5)/10)
					* Math.pow(stroke.lipidRatio, lipidRatio-5.11)
					* (atrialFibrillation ? stroke.atrialFibrillation : 1);
		}
		
		public function chd_hazard(t:Number, duration:Number, q1:Number):Number {
			var d:Number = chd.diabetesDuration;
			return q1*Math.pow(d,duration)*(1-Math.pow(d,t))/(1-d);
		}
								   
		public function stroke_hazard(t:Number, duration:Number, q2:Number):Number {
			var d:Number = stroke.diabetesDuration;
			return q2*Math.pow(d,duration)*(1-Math.pow(d,t))/(1-d);
		}
		
		public function cvd_hazard(t:Number, duration:Number, q1:Number, q2:Number):Number {
			return chd_hazard(t, duration, q1) + stroke_hazard(t, duration, q2);
		}
								   
		/*
		Functionality moved to UserModel
		
		// chd intervention hazard
		public function chd_intervention(
			q1:Number, // input result of chd_q1 calculation above
			gender: String,
			delta_hba1c:Number,
			stop_smoking:Boolean,
			delta_ldl_cholesterol:Number,
			lose_weight:Boolean,
			become_active:Boolean,
			delta_ace_arb:Number):Number {
			
			return q1 					
					* Math.pow(chd.int_hba1c, delta_hba1c)
					* (stop_smoking ? (gender == "male" ? chd.int_stop_smoking_man : chd.int_stop_smoking_woman) : 1)
					* Math.pow(chd.int_ldl_cholesterol, delta_ldl_cholesterol)
					* (lose_weight ? chd.int_lose_weight : 1)
					* (become_active ? chd.int_become_active : 1)
					* Math.pow(chd.int_ace_arb, delta_ace_arb);
			}
		
		// stroke intervention hazard
		public function stroke_intervention(
			gender: String,
			delta_hba1c:Number,
			stop_smoking:Boolean,
			delta_ldl_cholesterol:Number,
			lose_weight:Boolean,
			become_active:Boolean,
			delta_ace_arb:Number,
			delta_sbp:Number):Number {
			
			return Math.pow(stroke.int_hba1c, delta_hba1c)
				* (stop_smoking ? (gender == "male" ? stroke.int_stop_smoking_man : stroke.int_stop_smoking_woman) : 1)
				* Math.pow(stroke.int_ldl_cholesterol, delta_ldl_cholesterol)
				* (lose_weight ? stroke.int_lose_weight : 1)
				* (become_active ? stroke.int_become_active : 1)
				* Math.pow(stroke.int_ace_arb, delta_ace_arb)
				* Math.pow(stroke.int_sbp, delta_sbp);
		}
		
		// noncv intervention hazard
		public function noncv_intervention(
		gender: String,
		stop_smoking:Boolean):Number {
		
		return (stop_smoking ? (gender == "male" ? noncv.int_stop_smoking_man : noncv.int_stop_smoking_woman) : 1)
		}
		
		*/
		
		// See pub/UKPDS_CVD_risk_calculations.xls sheet NonCV_deaths
		public var noncvHazards:Object = {
			male: [
				7.90137E-05,	// age 15-19 
				0.000133194,
				0.000143669,
				0.000199713,
				0.000258065,
				0.000348351,
				0.000467034,
				0.000702241,
				0.001146881,
				0.001753914,
				0.002772194,
				0.004461065,
				0.007261039,
				0.012194485,
				0.020464998,
				0.032819149		// age 90+
				],
			female: [
				4.79024E-05,
				4.89034E-05,
				7.00618E-05,
				9.9383E-05,
				0.000157935,
				0.000234685,
				0.000343464,
				0.000572175,
				0.000885459,
				0.00130958,
				0.001957654,
				0.003138759,
				0.005154684,
				0.008906468,
				0.015392838,
				0.031704398
				],
			maleSmoker: [
				0.000206226,
				0.000347637,
				0.000374977,
				0.000521252,
				0.000673551,
				0.000909195,
				0.00121896,
				0.001832848,
				0.002993358,
				0.004577715,
				0.007235427,
				0.011643379,
				0.018951311,
				0.031827606,
				0.053413646,
				0.085657979
			],
			femaleSmoker: [
				0.000125025,
				0.000127638,
				0.000182861,
				0.00025939,
				0.000412211,
				0.000612527,
				0.00089644,
				0.001493377,
				0.002311048,
				0.003418003,
				0.005109478,
				0.008192161,
				0.013453725,
				0.023245883,
				0.040175306,
				0.08274848
			]
		};
		
	}
}
