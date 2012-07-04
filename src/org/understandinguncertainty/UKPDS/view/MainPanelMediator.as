/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import mx.states.State;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.personal.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.personal.signals.ScreenChangedSignal;
	import org.understandinguncertainty.personal.signals.ScreensNamedSignal;
	
	public class MainPanelMediator extends Mediator
	{

		[Inject]
		public var mainPanel:MainPanel;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var releaseScreenSignal:ReleaseScreenSignal;
				
		[Inject]
		public var screensNamedSignal:ScreensNamedSignal;
		
		override public function onRegister():void
		{
			screenChangedSignal.add(changeScreen);
			screensNamedSignal.dispatch(screens);
		}
		
		override public function onRemove():void
		{
			screenChangedSignal.remove(changeScreen);
		}
		
		private function changeScreen(s:String):void
		{
			selectedScreen = s;
		}
		
		private var _screens:Array;

		public function get screens():Array 
		{
			if(_screens) return _screens;
			
			var states:Array = mainPanel.states;
			_screens = [];
			for(var i:int = 0; i < states.length; i++) {
				_screens[i] = (states[i] as State).name;
			}
			return _screens;
		}
				
		public function get selectedScreen():String
		{
			return mainPanel.currentState;
		}
		public function set selectedScreen(s:String):void
		{
			mainPanel.currentState = s;
			
			if(s == "profile") {
				releaseScreenSignal.dispatch();
			}
		}

	}
}