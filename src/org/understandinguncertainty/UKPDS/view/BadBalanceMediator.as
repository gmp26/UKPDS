/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import mx.graphics.SolidColor;
	
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.personal.signals.NumbersAvailableSignal;

	public class BadBalanceMediator extends DifferenceBalanceMediator
	{
		[Inject]
		public var badBalance:BadBalance;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
		
		public function BadBalanceMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			//trace("badBalance register");
			differenceBalance = badBalance;
			super.onRegister();
			
			showDifferences = appState.showDifferences;
//			fill = new SolidColor(0xdd4444);
			fill = new SolidColor(0xCC0077);
			
			numbersAvailableSignal.add(updateView);
			
			var colourNumbers:ColourNumbersVO = model.colourNumbers;
			if(colourNumbers)
				updateView(model.colourNumbers, model.showDifferences);

		}
		
		override public function onRemove():void
		{
			//trace("badBalance remove");
			numbersAvailableSignal.remove(updateView);
			super.onRemove();
		}
		
		private function updateView(colours:ColourNumbersVO, selected:Boolean):void
		{
			//trace("badBalance update");
			leftNumber = colours.red;
			rightNumber = colours.red_int;
			showDifferences = selected;
			text = "suffered a heart attack or stroke";			
		}
	}
}

