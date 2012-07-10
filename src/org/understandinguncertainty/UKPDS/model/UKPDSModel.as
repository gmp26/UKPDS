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
			var a_gp:Number
			var b:Number;
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
			

			var q2_stroke:Number = parameters.stroke_q1(
				userProfile.ageAtDiagnosis,
				userProfile.gender,
				userProfile.smokerAtDiagnosis,
				userProfile.sbp,
				userProfile.lipidRatio,
				userProfile.atrialFibrillation
			);

			
			// Kick off calculation at t=0;
			var expH0:Number = Math.exp(-parameters.cvd_hazard(0, userProfile.diabetesDuration, q1_chd, q2_stroke));
			var maxQuarters:int = Math.floor((appState.maxAge - userProfile.ageAtDiagnosis)*4);
			
			for(var quarter:int=0; quarter <= maxQuarters; quarter++) {
				
				var t:Number = quarter/4;
				var expH1:Number = Math.exp(-parameters.cvd_hazard(t, userProfile.diabetesDuration, q1_chd, q2_stroke));
				var a = expH1 - expH0;
				expH0 = expH1;
				
				var calculatedParams:CalculatedParams = calculateOneYear(quarter);
			}
			_resultSet = new ArrayCollection(series_deanfield);
			
			modelUpdatedSignal.dispatch();
		}		
		
		private function calculateOneYear(quarter:int):CalculatedParams
		{
			
			var H:CalculatedParams;
			return H;
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
