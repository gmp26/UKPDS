/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.signals
{
	import org.osflash.signals.Signal;
	
	public class NumbersAvailableSignal extends Signal
	{
		public function NumbersAvailableSignal()
		{
			super(Object, Boolean);
		}
	}
}