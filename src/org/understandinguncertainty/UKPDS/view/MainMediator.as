/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.UKPDS.model.vo.WidthHeightMeasurement;
	import org.understandinguncertainty.UKPDS.support.ProfileLoader;
	import org.understandinguncertainty.personal.signals.ProfileDefaultsLoadedSignal;
	import org.understandinguncertainty.personal.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.personal.signals.ScreenChangedSignal;

	
	public class MainMediator extends Mediator
	{
		public function MainMediator()
		{
			super();
		}
		
		[Inject]
		public var main:Main;
		
		[Inject]
		public var releaseScreenSignal:ReleaseScreenSignal;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var profileLoader:ProfileLoader;
		
		[Inject]
		public var userProfile:UserModel;
		
		[Inject]
		public var profileDefaultsLoaded:ProfileDefaultsLoadedSignal;
		
		private static const defaultsURL:String = "personaldata.php";
		private static const defaultsURL2:String = "personaldata.xml";
		
		override public function onRegister():void
		{
			releaseScreenSignal.add(releaseScreen);
			screenChangedSignal.add(screenChanged);	
			main.credits.addEventListener(MouseEvent.CLICK, showCredits);

			// Load defaults from server
			profileLoader.load(defaultsURL, defaultsLoaded);
			
		}
		
		override public function onRemove():void
		{
			releaseScreenSignal.remove(releaseScreen);
			screenChangedSignal.remove(screenChanged);	
			main.credits.removeEventListener(MouseEvent.CLICK, showCredits);
		}
		
		private function releaseScreen():void 
		{
			main.fullScreen.releaseScreen();
		}
		
		private function screenChanged(s:String):void
		{
			if(s == "profile") {
				main.currentState = "profileOnly";	
			}
			else {
				main.fullScreen.buttonEnabled = (s != "profile");
				main.currentState = "riskScreens";
			}
		}

		private function showCredits(event:MouseEvent):void
		{
			var credits:Credits = PopUpManager.createPopUp(main, Credits, true) as Credits;
			credits.addEventListener(CloseEvent.CLOSE, closeCredits);
			PopUpManager.centerPopUp(credits);
		}
		
		private function closeCredits(event:CloseEvent):void
		{
			var credits:Credits = event.currentTarget as Credits;
			credits.removeEventListener(CloseEvent.CLOSE, closeCredits);
			PopUpManager.removePopUp(credits);
		}
		
		private function defaultsLoaded(event:Event):void {
			if(event.type == Event.COMPLETE) {
				// read profile from XML
				var xml:XML = profileLoader.xmlData(event);
				try {
					userProfile.variableList.readXML(xml);
				}
				catch (e:Error) {
					Alert.show(e.message, "Error parsing "+defaultsURL, Alert.OK);
				}
				profileDefaultsLoaded.dispatch();
			}
			else {
				// Load defaults from server
				Alert.show("Unable to read "+defaultsURL, "Load Default Parameters Error", Alert.OK);
				profileLoader.load(defaultsURL2, defaults2Loaded);
			}
		}
		
		private function defaults2Loaded(event:Event):void {
			if(event.type == Event.COMPLETE) {
				// read profile from XML
				var xml:XML = profileLoader.xmlData(event);
				try {
					userProfile.variableList.readXML(xml);
				}
				catch (e:Error) {
					Alert.show(e.message, "Error parsing "+defaultsURL2, Alert.OK);
				}
				profileDefaultsLoaded.dispatch();
			}
			else {
				// barf somehow...
				Alert.show("Unable to read "+defaultsURL+" or "+defaultsURL2, "Load Default Parameters Error", Alert.OK);
			}
		}
		
	}
}