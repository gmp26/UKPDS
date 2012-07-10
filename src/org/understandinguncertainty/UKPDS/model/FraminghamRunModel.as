/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	
	import org.understandinguncertainty.UKPDS.model.vo.BetasVO;
	import org.understandinguncertainty.UKPDS.model.vo.CalculatedParams;
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;

	[ResourceBundle("UKPDS")]
	public class FraminghamRunModel extends AbstractModel implements ICardioModel
	{	
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
		
		private var _maleParams:MaleParameters;
		private function get maleParameters():MaleParameters
		{
			return _maleParams || new MaleParameters();
		}
		
		private var _femaleParams:FemaleParameters;
		private function get femaleParameters():FemaleParameters
		{
			return _femaleParams || new FemaleParameters();
		}
		
		private function get framinghamParams():FraminghamParameters
		{
			return (userProfile.gender == "male") ? maleParameters : femaleParameters;
		}
		
		public function recalculate():void {


			_peakf = 0;
			
			if(userProfile.age == 0)
				return;
			appState.minimumAge = userProfile.age;

			var series:Array= [];
			var series_star:Array= [];
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
			var nonSmoker:Boolean = profile.nonSmoker.value as Boolean;
			var quitSmoker:Boolean = profile.quitSmoker.value as Boolean;
			var profile_int:VariableList = interventionProfile.variableList;
			var nonSmoker_int:Boolean = profile_int.nonSmoker.value as Boolean;
			var quitSmoker_int:Boolean = profile_int.quitSmoker.value as Boolean;

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
			
			for(var i:int=userProfile.age; i <= appState.maximumAge; i++) {
				
				var calculatedParams:CalculatedParams = calculateOneYear(i);
				
				a = calculatedParams.a;
				a_gp = calculatedParams.genPop_a;
				
				var b0:Number = framinghamParams.b[i];
				b = nonSmoker ? (quitSmoker ? 0.65*1.46*b0 : 0.88*b0) : 1.46*b0;
				if(i == userProfile.age)
					heartAge = calculatedParams.h;
				if(i < appState.interventionAge) {
					b_int = b;
					a_int = a;
				}
				else {
					a_int = calculatedParams.a_int;					
					b_int = nonSmoker_int ? (quitSmoker_int ? 0.65*1.46*b0 : 0.88*b0) : 1.46*b0;
				}
								
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
													
				// outlook yellow
				var yellow:Number = f+m - (m_int+f_int);
				
				// cope with rare occasions when m+f > 100
				var greenUnclamped:Number = 100 - Math.max(m + f, m_int + f_int);
				if(greenUnclamped < 0)
					yellow = Math.min(0, yellow + greenUnclamped);
				yellow = Math.max(0,yellow);
				
				var green:Number = Math.min(100, Math.max(0, greenUnclamped));
				var red:Number = f_int;
								
				series_deanfield.push({
					age:		i+1,
					
					// for Outlook (+ve)
					green:		green,
					yellow:		green + yellow,		
					red:		green + yellow + red,					

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
		
		private function calculateOneYear(i:int):CalculatedParams
		{
			
			var p:FraminghamParameters = framinghamParams;
			var beta:BetasVO = framinghamParams.beta;
			var q:BetasVO = framinghamParams.q;
			var profile:VariableList = userProfile.variableList;
			var profile_int:VariableList = interventionProfile.variableList;

			var ageBetaX:Number = Math.log(i) * beta.age;
			
			var tCBetaX:Number = Math.log(appState.mmolConvert*(profile.totalCholesterol_mmol_L.value as Number)) * beta.totalCholesterol_mmol_L;
			var tCBetaX_1:Number = Math.log(appState.mmolConvert*(profile_int.totalCholesterol_mmol_L.value as Number)) * beta.totalCholesterol_mmol_L;
			var tCBetaX_int:Number = (1-q.totalCholesterol_mmol_L)*tCBetaX + q.totalCholesterol_mmol_L*tCBetaX_1;
			
			var hdlBetaX:Number = Math.log(appState.mmolConvert*(profile.hdlCholesterol_mmol_L.value as Number)) * beta.hdlCholesterol_mmol_L;
			var hdlBetaX_1:Number = Math.log(appState.mmolConvert*(profile_int.hdlCholesterol_mmol_L.value as Number)) * beta.hdlCholesterol_mmol_L;
			var hdlBetaX_int:Number = (1-q.hdlCholesterol_mmol_L)*hdlBetaX + q.hdlCholesterol_mmol_L*hdlBetaX_1;

			// Note that the SBP may change AND/OR it may be treated during the intervention, so we calculate the effect before
			// and after taking both of these into account. Then we interpolate.
			var SBPTreated:Boolean = (profile.SBPTreated.value as Boolean);
			var sbpBetaX:Number = Math.log(profile.systolicBloodPressure.value as Number);
			if(SBPTreated)
				sbpBetaX *= beta.SBPTreated;
			else
				sbpBetaX *= beta.systolicBloodPressure;

			SBPTreated = (profile_int.SBPTreated.value as Boolean);
			var sbpBetaX_int:Number = Math.log(profile_int.systolicBloodPressure.value as Number);
			if(SBPTreated)
				sbpBetaX_int *= beta.SBPTreated;
			else
				sbpBetaX_int *= beta.systolicBloodPressure;
			
			// Now interpolate
			var smokerBetaX:Number = (profile.nonSmoker.value as Boolean) ? 0 : beta.smoker;
			var smokerBetaX_int:Number;
			if(profile_int.nonSmoker.value as Boolean) {
				smokerBetaX_int = (1 - q.smoker)*smokerBetaX;
			}
			else {
				smokerBetaX_int = (1 - q.smoker)*smokerBetaX + q.smoker*beta.smoker;
			}
			
			var diabeticBetaX:Number = (profile.diabetic.value as Boolean) ? beta.diabetic : 0;
			var diabeticBetaX_int:Number = (1 - q.diabetic)*diabeticBetaX
				+ ((profile_int.diabetic.value as Boolean) ? (q.diabetic * beta.diabetic) : 0);
			
			var sumBetaX:Number = ageBetaX + tCBetaX + hdlBetaX + sbpBetaX + smokerBetaX + diabeticBetaX;
			var sumBetaX_int:Number = ageBetaX + tCBetaX_int + hdlBetaX_int + sbpBetaX_int + smokerBetaX_int + diabeticBetaX_int;
			
			var lhr:Number = sumBetaX - p.averageHazard;
			var lhr_int:Number = sumBetaX_int - p.averageHazard;

			// heartAge
			var h:Number
			if(i == userProfile.age)
				h = Math.exp(lhr/beta.age + p.xbar.age);

			//trace("fram age: "+i+" a: "+lhr);
			
			return new CalculatedParams(p.a * Math.exp(lhr), p.a*Math.exp(lhr_int), h, p.a*Math.exp(ageBetaX-p.xbar.age*p.beta.age));
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
