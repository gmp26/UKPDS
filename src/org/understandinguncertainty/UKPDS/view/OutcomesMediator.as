/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	
	public class OutcomesMediator extends Mediator
	{
		
		[Inject]
		public var outcomes:Outcomes;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var userProfile:UserModel;
		
		[Inject]
		public var appState:AppState;
		
		public function OutcomesMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			//trace("Outcomes register");
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("Outcomes remove");
			modelUpdatedSignal.remove(updateView);
		}
				
		private function updateView() : void
		{
			if(runModel) {
				
				var targetAge:int = userProfile.age + appState.targetInterval;
				var dataProvider:ArrayCollection = runModel.getResultSet();
				if(appState.targetInterval >= dataProvider.length)
					appState.targetInterval = dataProvider.length - 1;
				var targetItem:Object = dataProvider.getItemAt(appState.targetInterval);
				
				outcomes.smileySquare.f = targetItem.fdash;
				outcomes.smileySquare.f_int = targetItem.fdash_int;
				outcomes.smileySquare.m = targetItem.mdash;
				outcomes.smileySquare.m_int = targetItem.mdash_int;
				outcomes.targetIntervalLabel.text=appState.targetInterval.toString();
				outcomes.ageLabel.text=(appState.minimumAge+appState.targetInterval).toString();				
			}
		}
		
	}
}