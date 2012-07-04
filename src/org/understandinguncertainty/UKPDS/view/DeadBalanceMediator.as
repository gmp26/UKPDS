/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import mx.graphics.SolidColor;
	
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.personal.signals.NumbersAvailableSignal;

	public class DeadBalanceMediator extends DifferenceBalanceMediator
	{
		[Inject]
		public var deadBalance:DeadBalance;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
				
		public function DeadBalanceMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			differenceBalance = deadBalance;
			super.onRegister();
			/*
			var colours:ColourNumbersVO = runModel.colourNumbers;
			leftNumber = colours.blue;
			rightNumber = colours.blue_int;
			*/
			showDifferences = appState.showDifferences;
			fill = new SolidColor(0x88aaff);
			
			numbersAvailableSignal.add(updateView);
			
			var colourNumbers:ColourNumbersVO = runModel.colourNumbers;
			if(colourNumbers)
				updateView(runModel.colourNumbers, runModel.showDifferences);
		}
		
		override public function onRemove():void
		{
			numbersAvailableSignal.remove(updateView);
			super.onRemove();
		}
		
		
		private function updateView(colours:ColourNumbersVO, selected:Boolean):void
		{
			leftNumber = colours.blue;
			rightNumber = colours.blue_int;
			showDifferences = selected;
			text = "died before heart attack or stroke";
			
		}
		
	}
}

