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
	import org.understandinguncertainty.personal.signals.ProfileDefaultsLoadedSignal;
	
	public class FuturesMediator extends Mediator
	{
		[Inject]
		public var futures:Futures;
		
		[Inject]
		public var model:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var userProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		[Inject]
		public var profileDefaultsLoaded:ProfileDefaultsLoadedSignal;
		public var meanAge:Number;
						
		override public function onRegister() : void
		{
			//trace("heartAge register");		
			modelUpdatedSignal.add(updateView);
			profileDefaultsLoaded.add(recalcModel);
			model.recalculate();
		}
		
		override public function onRemove():void
		{
			//trace("heartAge remove");
			modelUpdatedSignal.remove(updateView);
			profileDefaultsLoaded.remove(recalcModel);
		}
		
		private function recalcModel():void 
		{
			model.recalculate();
			updateView();
		}
		
		private function updateView():void
		{
			if(appState.selectedScreenName != "futures") {
				
				// flashScore_gp may not be valid
				return;
			}

			var yg:String;
			if(model.yearGain >= 0.1) {
				yg = model.yearGain.toPrecision(2);
				futures.gainText.visible = true;
				futures.gainText.text = "gaining " + yg + " years through interventions"
			}
			else if(model.yearGain <= -0.1) {
				yg = (-model.yearGain).toPrecision(2);
				futures.gainText.visible = true;
				futures.gainText.text = "losing " + yg + " years through interventions"
			}
			else {
				futures.gainText.visible = false;
			}
			
			meanAge = model.meanAge;
			futures.meanSurvival.text = "On average, expect\nto survive to age " + Math.floor(meanAge) + "\nwithout a heart attack or stroke";
			var yGain:Number = Math.max(0, model.yearGain);
			var yLoss:Number = Math.min(0, model.yearGain);
			futures.thermometer.dataProvider = new ArrayCollection([{
				meanYears:model.meanAge - yGain - yLoss,
				yearLoss:yLoss,
				yearGain:yGain, 
				summary:""
			}]);

			futures.hAxis.minimum = userProfile.age;
			futures.hAxis.maximum = 102; //5*Math.ceil((model.meanAge + 5)/5);
			//futures.futuresText.text = model.heartAgeText;
		}
		
	}
}