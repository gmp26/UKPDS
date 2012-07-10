/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.NumbersAvailableSignal;
	import org.understandinguncertainty.personal.signals.ShowDifferencesChangedSignal;
	
	public class BalanceMediator extends Mediator
	{
		
		[Inject]
		public var balance:Balance;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var numbersAvailableSignal:NumbersAvailableSignal;
		
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		public function BalanceMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			trace("Balance register");
			modelUpdatedSignal.add(updateView);
			model.recalculate();
			balance.differenceCheckBox.addEventListener(Event.CHANGE, updateView);
		}
		
		override public function onRemove():void
		{
			trace("Balance remove");
			modelUpdatedSignal.remove(updateView);
			balance.differenceCheckBox.removeEventListener(Event.CHANGE, updateView);
		}
				
		private function updateView(event:Event = null) : void
		{
			trace("Balance updateView");
			var colours:ColourNumbersVO = model.colourNumbers;
			appState.showDifferences = balance.differenceCheckBox.selected;
			
			balance.title.text = "What we expect to happen in "+appState.targetInterval+" years to 100 people like you";
			balance.leftSubtitle.text = "carrying on as usual";
			balance.rightSubtitle.text = "after interventions";
			
			model.showDifferences = balance.differenceCheckBox.selected;
			numbersAvailableSignal.dispatch(colours, model.showDifferences);
		}
	}
}