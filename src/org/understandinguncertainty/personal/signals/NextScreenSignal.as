/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.signals
{
	import org.osflash.signals.Signal;
	
	public class NextScreenSignal extends Signal
	{
		public function NextScreenSignal()
		{
			super(String); // current ScreenName or State name
		}
	}
}