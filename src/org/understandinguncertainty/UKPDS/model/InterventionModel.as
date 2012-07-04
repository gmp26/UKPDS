/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{

	/**
	 * Class which models interventions
	 */
	public class InterventionModel
	{
		public function cholesterolIntervention(a:Number, difference:Number, difference_int:Number):Number
		{
			// Cholesterol adjustment
			return a + (difference - difference_int)*Math.log(0.78);
		}
		
		public function sbpIntervention(a:Number, sbp:Number, sbp_int:Number):Number
		{
			// Blood Pressure adjustment
			return a + (sbp - sbp_int)*Math.log(0.966);
		}
		
		public function smokingIntervention(a:Number, LHR:Number, LHR_int:Number):Number
		{
			// smoking adjustment
			return a + LHR - LHR_int;
		}
	}
}