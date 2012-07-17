/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	
	public class AppState
	{
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		public const mmolConvert:Number = 38.7;
		public var mmol:Boolean = true;
		
		public const hbA1cConvert:Number = 38.7;
		public var hbA1c_Percent:Boolean = true;
		
		public var showDifferences:Boolean = false;
		public var interventionAge:int = 0;
		public var targetInterval:int = 10;
		public var maximumAge:int = 110;
		public var selectedScreenName:String = "profile";
		
		private var _minimumAge:int = 15;

		public function get minimumAge():int
		{
			return _minimumAge;
		}

		public function set minimumAge(value:int):void
		{
			if(interventionAge < value)
				interventionAge = value;
			_minimumAge = value;
		}

		
	}
	
	
}