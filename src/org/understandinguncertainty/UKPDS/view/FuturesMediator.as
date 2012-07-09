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
	
	public class FuturesMediator extends Mediator
	{
		[Inject]
		public var futures:Futures;
		
		[Inject]
		public var runModel:ICardioModel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var userProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
		
		public var meanAge:Number;
						
		override public function onRegister() : void
		{
			//trace("heartAge register");		
			modelUpdatedSignal.add(updateView);
			runModel.commitProperties();
		}
		
		override public function onRemove():void
		{
			//trace("heartAge remove");
			modelUpdatedSignal.remove(updateView);
		}
		
		private function updateView():void
		{
			if(appState.selectedScreenName != "futures") {
				
				// flashScore_gp may not be valid
				return;
			}

			var yg:String;
			if(runModel.yearGain >= 0.1) {
				yg = runModel.yearGain.toPrecision(2);
				futures.gainText.visible = true;
				futures.gainText.text = "gaining " + yg + " years through interventions"
			}
			else if(runModel.yearGain <= -0.1) {
				yg = (-runModel.yearGain).toPrecision(2);
				futures.gainText.visible = true;
				futures.gainText.text = "losing " + yg + " years through interventions"
			}
			else {
				futures.gainText.visible = false;
			}
			
			meanAge = runModel.meanAge;
			futures.meanSurvival.text = "On average, expect\nto survive to age " + Math.floor(meanAge) + "\nwithout a heart attack or stroke";
			var yGain:Number = Math.max(0, runModel.yearGain);
			var yLoss:Number = Math.min(0, runModel.yearGain);
			futures.thermometer.dataProvider = new ArrayCollection([{
				meanYears:runModel.meanAge - yGain - yLoss,
				yearLoss:yLoss,
				yearGain:yGain, 
				summary:""
			}]);

			futures.hAxis.minimum = userProfile.age;
			futures.hAxis.maximum = 102; //5*Math.ceil((runModel.meanAge + 5)/5);
			//futures.futuresText.text = runModel.heartAgeText;
		}
	}
}