/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import mx.graphics.SolidColor;
	
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.personal.signals.NumbersAvailableSignal;

	public class GoodBalanceMediator extends DifferenceBalanceMediator
	{
		[Inject]
		public var goodBalance:GoodBalance;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
		
		public function GoodBalanceMediator()
		{
			super();
		}

		
		override public function onRegister():void
		{
			differenceBalance = goodBalance;
			super.onRegister();
			/*
			var colours:ColourNumbersVO = model.colourNumbers;
			leftNumber = colours.green;
			rightNumber = colours.green_int;
			*/
			showDifferences = appState.showDifferences;
			fill = new SolidColor(0x22AA00);
			
			numbersAvailableSignal.add(updateView);
			
			var colourNumbers:ColourNumbersVO = model.colourNumbers;
			if(colourNumbers)
				updateView(model.colourNumbers, model.showDifferences);
		}
		
		override public function onRemove():void
		{
			numbersAvailableSignal.remove(updateView);
			super.onRemove();
		}
		
		private function updateView(colours:ColourNumbersVO, selected:Boolean):void
		{
			leftNumber = colours.green;
			rightNumber = colours.green_int;
			showDifferences = selected;
			text = "living without heart attack or stroke";
		}

		
	}
}

