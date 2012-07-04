/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS
{
	import flash.display.DisplayObjectContainer;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.robotlegs.mvcs.SignalContext;
	import org.understandinguncertainty.UKPDS.controller.SetupInterventionProfile;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.UKPDS.model.ICardioModel;
	import org.understandinguncertainty.UKPDS.model.QRunModel;
	import org.understandinguncertainty.UKPDS.model.RunModel;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.signals.ClearInterventionsSignal;
	import org.understandinguncertainty.personal.signals.InterventionEditedSignal;
	import org.understandinguncertainty.personal.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.personal.signals.NextScreenSignal;
	import org.understandinguncertainty.personal.signals.NumbersAvailableSignal;
	import org.understandinguncertainty.personal.signals.ProfileCommitSignal;
	import org.understandinguncertainty.personal.signals.ProfileLoadSignal;
	import org.understandinguncertainty.personal.signals.ProfileSaveSignal;
	import org.understandinguncertainty.personal.signals.ProfileValidSignal;
	import org.understandinguncertainty.personal.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.personal.signals.ScreenChangedSignal;
	import org.understandinguncertainty.personal.signals.ScreensNamedSignal;
	import org.understandinguncertainty.personal.signals.ShowDifferencesChangedSignal;
	import org.understandinguncertainty.personal.signals.UpdateModelSignal;
	import org.understandinguncertainty.UKPDS.view.AgeSettings;
	import org.understandinguncertainty.UKPDS.view.AgeSettingsMediator;
	import org.understandinguncertainty.UKPDS.view.BadBalance;
	import org.understandinguncertainty.UKPDS.view.BadBalanceMediator;
	import org.understandinguncertainty.UKPDS.view.Balance;
	import org.understandinguncertainty.UKPDS.view.BalanceMediator;
	import org.understandinguncertainty.UKPDS.view.Compare;
	import org.understandinguncertainty.UKPDS.view.CompareMediator;
	import org.understandinguncertainty.UKPDS.view.DeadBalance;
	import org.understandinguncertainty.UKPDS.view.DeadBalanceMediator;
	import org.understandinguncertainty.UKPDS.view.DeanfieldChart;
	import org.understandinguncertainty.UKPDS.view.DeanfieldChartMediator;
	import org.understandinguncertainty.UKPDS.view.DifferenceBalance;
	import org.understandinguncertainty.UKPDS.view.DifferenceBalanceMediator;
	import org.understandinguncertainty.UKPDS.view.Futures;
	import org.understandinguncertainty.UKPDS.view.FuturesMediator;
	import org.understandinguncertainty.UKPDS.view.GoodBalance;
	import org.understandinguncertainty.UKPDS.view.GoodBalanceMediator;
	import org.understandinguncertainty.UKPDS.view.HeartAge;
	import org.understandinguncertainty.UKPDS.view.HeartAgeMediator;
	import org.understandinguncertainty.UKPDS.view.InterventionsPanel;
	import org.understandinguncertainty.UKPDS.view.InterventionsPanelMediator;
	import org.understandinguncertainty.UKPDS.view.Main;
	import org.understandinguncertainty.UKPDS.view.MainMediator;
	import org.understandinguncertainty.UKPDS.view.MainPanel;
	import org.understandinguncertainty.UKPDS.view.MainPanelMediator;
	import org.understandinguncertainty.UKPDS.view.Outcomes;
	import org.understandinguncertainty.UKPDS.view.OutcomesMediator;
	import org.understandinguncertainty.UKPDS.view.Profile;
	import org.understandinguncertainty.UKPDS.view.ProfileMediator;
	import org.understandinguncertainty.UKPDS.view.QProfile;
	import org.understandinguncertainty.UKPDS.view.QProfileMediator;
	import org.understandinguncertainty.UKPDS.view.RiskByAge;
	import org.understandinguncertainty.UKPDS.view.RiskByAgeMediator;
	import org.understandinguncertainty.UKPDS.view.ScreenSelector;
	import org.understandinguncertainty.UKPDS.view.ScreenSelectorMediator;
	
	public class UKPDSContext extends SignalContext
	{
				
		public function UKPDSContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup() : void
		{
			
			// inject ResourceManager
			injector.mapValue(IResourceManager, ResourceManager.getInstance());

			// Model
			injector.mapSingleton(AppState);
			
			var userProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, userProfile, "userProfile");
			
			var interventionProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, interventionProfile, "interventionProfile");	
			

			// RunModel uses Framingham
			// injector.mapSingletonOf(ICardioModel, RunModel); 
			injector.mapSingletonOf(ICardioModel, QRunModel);
			
			// Signals
			injector.mapSingleton(ProfileValidSignal);
			injector.mapSingleton(ProfileLoadSignal);
			injector.mapSingleton(ProfileSaveSignal);
			injector.mapSingleton(ProfileCommitSignal);
			injector.mapSingleton(ReleaseScreenSignal);
			injector.mapSingleton(ScreenChangedSignal);
			injector.mapSingleton(ScreensNamedSignal);
			injector.mapSingleton(NextScreenSignal);
			injector.mapSingleton(ClearInterventionsSignal);
			injector.mapSingleton(ShowDifferencesChangedSignal);
			
			injector.mapSingleton(InterventionEditedSignal);
			injector.mapSingleton(UpdateModelSignal);
			injector.mapSingleton(ModelUpdatedSignal);
			injector.mapSingleton(NumbersAvailableSignal);

			// View
			mediatorMap.mapView(Main, MainMediator);
			mediatorMap.mapView(MainPanel, MainPanelMediator);
			mediatorMap.mapView(ScreenSelector, ScreenSelectorMediator);
			
			// Profile and ProfileMediator adopt a FRamingham profile
			//mediatorMap.mapView(Profile, ProfileMediator);
			mediatorMap.mapView(QProfile, QProfileMediator);
			
			mediatorMap.mapView(InterventionsPanel, InterventionsPanelMediator);
			mediatorMap.mapView(HeartAge, HeartAgeMediator);
			mediatorMap.mapView(Futures, FuturesMediator);
			mediatorMap.mapView(AgeSettings, AgeSettingsMediator);
			mediatorMap.mapView(DeanfieldChart, DeanfieldChartMediator);
			mediatorMap.mapView(RiskByAge, RiskByAgeMediator);
			mediatorMap.mapView(Outcomes, OutcomesMediator);
			
			mediatorMap.mapView(Balance, BalanceMediator);
				mediatorMap.mapView(GoodBalance, GoodBalanceMediator);
				mediatorMap.mapView(BadBalance, BadBalanceMediator);
				mediatorMap.mapView(DeadBalance, DeadBalanceMediator);
			
			mediatorMap.mapView(Compare, CompareMediator);
			
						
			super.startup();
		}
	}
}