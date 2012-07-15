/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.UKPDS.model.vo.CalculatedParams;
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.UKPDS.model.vo.ParamsVO;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;

	[ResourceBundle("UKPDS")]
	public class UKPDSModel extends AbstractModel implements ICardioModel
	{	

		[Inject]
		public var parameters:UKPDSParameters;
		
		/* following are used in UKPDS */		
		public const intercept_CHD:Number = 0.0112;
		public const intercept_Stroke:Number = 0.00186;		

		private var _showDifferences:Boolean = false;
		
		/**
		 * @param b sets whether to show differences in the UI
		 */
		public function set showDifferences(b:Boolean):void {
			this._showDifferences = b;
		}
		
		/**
		 * @returns whether to show differences in the UI
		 */
		public function get showDifferences():Boolean {
			return _showDifferences;
		}
		
		public function recalculate():void {
			
			_peakf = 0;
			
			if(userProfile.age == 0)
				return;
			appState.minimumAge = userProfile.age;

			var series_deanfield:Array = [];

			var a:Number;
			var a_int:Number;
			var a_gp:Number;
			var b:Number;
			var b_gp:Number;
			var b_int:Number;
			
			var c:Number;
			var c_int:Number;
			var c_gp:Number;
			var d:Number;
			var d_int:Number;
			var d_gp:Number;
			var e:Number = 100;
			var e_int:Number = 100;
			var e_gp:Number = 100;
			var f:Number = 0;
			var f_int:Number = 0;
			var f_gp:Number = 0;
			var m:Number = 0;
			var m_int:Number = 0;
			var m_gp:Number = 0;
			var profile:VariableList = userProfile.variableList;
			var nonSmoker:Boolean = profile.smokerAtDiagnosis.value as Boolean;
//			var quitSmoker:Boolean = profile.quitSmoker.value as Boolean;

			sum_e = 0;
			sum_e_int = 0;
			
			// Push current age onto output array immediately
			series_deanfield.push({
				age:		userProfile.age,
				green:		100,
				yellow:		100,
				red:		100,					
				
				redNeg:	    0,
				yellowNeg: 	0,
				blueNeg:	0,

				yellowOnly:	100,
				redOnly:	100,
				
				fdash:		0, 
				fdash_int:	0,
				mdash:		0,
				mdash_int:	0,
				f_gp:		0
			});
			
			peakYellowNeg = 20;
			
			var q1_chd:Number = parameters.chd_q1(
				userProfile.ageAtDiagnosis,
				userProfile.gender,
				userProfile.afroCarib,
				userProfile.smokerAtDiagnosis,
				userProfile.hba1c,
				userProfile.sbp,
				userProfile.lipidRatio);
			
			var q1_chd_gp:Number = parameters.chd_q1(
				userProfile.ageAtDiagnosis,
				userProfile.gender,
				userProfile.afroCarib,
				false,
				userProfile.isMale ? 6.6 : 6.9,
				userProfile.isMale ? 133 : 139,
				userProfile.isMale ? 5.2 : 5.1);
			
			var chd_H_int:Number = q1_chd*userProfile.chdHazardForInterventions;

			var q2_stroke:Number = parameters.stroke_q2(
				userProfile.ageAtDiagnosis,
				userProfile.gender,
				userProfile.smokerAtDiagnosis,
				userProfile.sbp,
				userProfile.lipidRatio,
				userProfile.atrialFibrillation
			);
			
			var q2_stroke_gp:Number = parameters.stroke_q2(
				userProfile.ageAtDiagnosis,
				userProfile.gender,
				false,
				userProfile.isMale ? 133 : 139,
				userProfile.isMale ? 5.2 : 5.1,
				false
			);
			
			var stroke_H_int:Number = q2_stroke*userProfile.strokeHazardForInterventions;

			var T:Number = userProfile.diabetesDuration;
			
			// Kick off calculation at t=0;
			var expH0:Number = 1; //Math.exp(-parameters.cvd_hazard(0, userProfile.diabetesDuration, q1_chd, q2_stroke));
			var expH0_int:Number = 1; //Math.exp(-parameters.cvd_hazard(0, userProfile.diabetesDuration, chd_H_int, stroke_H_int));
			var expH0_gp:Number = 1;//Math.exp(-parameters.cvd_hazard(0, userProfile.diabetesDuration, q1_chd_gp, q2_stroke_gp));

			var b0:Number = 0;
			var b0_int:Number = 0;
			var b0_gp:Number = 0;
			
			var maxQuarters:int = Math.floor((appState.maximumAge - userProfile.ageAtDiagnosis)*4);
			
			var a_now:Number = 0;
			heartAge = userProfile.ageAtDiagnosis;
			
			for(var quarter:int=1; quarter <= maxQuarters; quarter++) {
				
				var t:Number = quarter/4;
				var age:Number = userProfile.ageAtDiagnosis+t;
				
				// for debug
				var H1:Number = parameters.chd_hazard(t, T, q1_chd);
				var H2:Number = parameters.stroke_hazard(t, T, q2_stroke);
				var H:Number = H1+H2;

				// Calculate cvd risk for quarter
				var expH1:Number = Math.exp(-H); //Math.exp(-parameters.cvd_hazard(t, 0.25, q1_chd, q2_stroke));
				a = expH0 - expH1; // section 1.4 of the paper has this the wrong way round
				expH0 = expH1;
				//expH0_int = expH0;
				
					
				// and for comparison
				var expH1_gp:Number = Math.exp(-parameters.cvd_hazard(t, T, q1_chd_gp, q2_stroke_gp));
				a_gp = expH0_gp - expH1_gp;
				expH0_gp = expH1_gp;
				
				// Calculate noncvd risk for quarter
				b = parameters.noncvdHazard(age, userProfile.gender, userProfile.smokerAtDiagnosis);
				
				// and after interventions
				if(age < appState.interventionAge) {
					expH0_int = Math.exp(-parameters.cvd_hazard(t, T, chd_H_int, stroke_H_int));
					a_int = a;
					b_int = b;
				}
				else {
					var expH1_int:Number = Math.exp(-parameters.cvd_hazard(t, T, chd_H_int, stroke_H_int));
					a_int = expH0_int - expH1_int;
					expH0_int = expH1_int;

					b_int = b * userProfile.nonCVDHazardForInterventions;
				}
				if(quarter == 1) {
					a_now = a_int;
				}
				
				// and for heart age calculation - we only look at cvd risk
				if(a_gp > a_now) {
					heartAge = userProfile.ageAtDiagnosis + t - 0.125;
					a_now = 1;
					trace("heartAge? ", t, a_gp, a, heartAge);
				}
				
				// and for comparison
				b_gp = parameters.noncvdHazard(age, userProfile.gender, false);
				
				c = e*b;
				c_int = e_int*b_int;
				c_gp = e_gp*b;
				
				d = e*a;
				d_int = e_int*a_int;
				d_gp = e_gp*a_gp;
				
				e -= (c+d);
				e_int -= (c_int+d_int);
				e_gp -= (c_gp + d_gp);
				sum_e_int += e_int;
				sum_e += e;
				
				f += d;
				f_int += d_int;
				f_gp += d_gp;
				
				m += c;
				m_int += c_int;
				m_gp += c_gp;
				
//				trace("base: ", t, a,b,c,d,e,f,m);
//				trace("intv: ", t, a_int,b_int,c_int,d_int,e_int,f_int,m_int);

				// outlook yellow
				var yellow:Number = f+m - (m_int+f_int);
				
				// outlook red
				var ored:Number = Math.min(0, yellow);
				
				// cope with rare occasions when m+f > 100
				var greenUnclamped:Number = 100 - Math.max(m + f, m_int + f_int);
				if(greenUnclamped < 0)
					yellow = Math.min(0, yellow + greenUnclamped);
				yellow = Math.max(0,yellow);
				
				var green:Number = Math.min(100, Math.max(0, greenUnclamped));
				var red:Number = f_int;
				
				
				if(quarter % 4) series_deanfield.push({
					age:		age,
					
					// for Outlook (+ve)
					green:		green,
					yellow:		green + yellow,		
					red:		green - ored,					
					
					// for Outlook (-ve)
					redNeg:	    f_int,					// f_int == f until interventions are entered
					yellowNeg: 	f_int + yellow,			// yellow is sitting on top of f_int
					blueNeg:	m_int + f_int + yellow, // no longer used
					
					yellowOnly: yellow,
					redOnly:	red,
					
					// for Outcomes
					fdash:		f, 
					fdash_int:	f_int,
					mdash:		m,
					mdash_int:	m_int,
					f_gp:		f_gp
				});
				
				_peakf = Math.max(_peakf, f);
				_peakf = Math.max(_peakf, f_int);
				peakYellowNeg = Math.max(f_int + yellow, peakYellowNeg);
			}
			_resultSet = new ArrayCollection(series_deanfield);
			
			modelUpdatedSignal.dispatch();
		}		
		
		private var _peakf:Number;
		
		/**
		 * @return peak cardiovascular risk
		 */   
		public function get peakf():Number 
		{
			return _peakf;	
		}
	}
}
