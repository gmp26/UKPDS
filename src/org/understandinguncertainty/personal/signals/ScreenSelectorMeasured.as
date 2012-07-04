/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.signals
{
	import org.osflash.signals.Signal;
	import org.understandinguncertainty.UKPDS.model.vo.WidthHeightMeasurement;
	
	public class ScreenSelectorMeasured extends Signal
	{
		public function ScreenSelectorMeasured()
		{
			super(WidthHeightMeasurement);
		}
	}
}