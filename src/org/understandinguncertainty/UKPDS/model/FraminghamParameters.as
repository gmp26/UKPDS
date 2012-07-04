/*
Copyright University of Cambridge. All rights reserved
*/
/**
 * Parameters for Framningham model [Dag2009]
 * See http://circ.ahajournals.org/cgi/content/full/117/6/743
 *
 * See MaleParameter and FemaleParameter subclasses for actual values. 
 */
package org.understandinguncertainty.UKPDS.model
{
	import org.understandinguncertainty.UKPDS.model.vo.BetasVO;

	public interface FraminghamParameters
	{
		
		// Dag2009 table 2
		function get beta():BetasVO;
		
		// Appendix 1 case 1 and case 2 xbar values
		function get xbar():BetasVO;
		
		// sum (beta_i * xbar_i)
		function get averageHazard():Number;
		
		// baseline risk - see DJS notes
		function get a():Number;
		
		// ONS: England & Wales 2005-2007 interim life tables
		function get b():Array;
		
		/**
		 * 
		 * @return the interpolation parameter to use when calculating the effect 
		 * of intervention. q = 0 means intervention has no effect. q = 1 means the
		 * value after intervention has the full effect.
		 * e.g. For a smoker, if we set q to 0.5, then the benefit of stopping smoking
		 * is half the benefit of never having smoked.
		 *  
		 */
		function get q():BetasVO;
		
	}
}