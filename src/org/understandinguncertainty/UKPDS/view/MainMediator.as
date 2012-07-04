/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.vo.WidthHeightMeasurement;
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
		
		override public function onRegister():void
		{
			releaseScreenSignal.add(releaseScreen);
			screenChangedSignal.add(screenChanged);	
			main.credits.addEventListener(MouseEvent.CLICK, showCredits);
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
			main.fullScreen.buttonEnabled = (s != "profile");
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
		
	}
}