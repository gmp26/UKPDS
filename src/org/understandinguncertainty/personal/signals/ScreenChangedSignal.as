/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.signals
{
	import org.osflash.signals.Signal;
	
	public class ScreenChangedSignal extends Signal
	{
		public function ScreenChangedSignal()
		{
			super(String); // new screen index
		}
	}
}