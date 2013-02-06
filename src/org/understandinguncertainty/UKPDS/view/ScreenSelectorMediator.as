/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Button;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.UKPDS.model.AppState;
	import org.understandinguncertainty.personal.signals.ProfileCommitSignal;
	import org.understandinguncertainty.personal.signals.ProfileValidSignal;
	import org.understandinguncertainty.personal.signals.ScreenChangedSignal;
	import org.understandinguncertainty.personal.signals.ScreensNamedSignal;
	
	import spark.components.Group;
	import spark.components.supportClasses.GroupBase;
		
	public class ScreenSelectorMediator extends Mediator
	{
		public function ScreenSelectorMediator()
		{
			super();
		}
		
		[Inject]
		public var profileValidSignal:ProfileValidSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var screenSelector:ScreenSelector;
		
		[Inject]
		public var screensNamedSignal:ScreensNamedSignal;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var appState:AppState;
		
		private var timer:Timer;
		
		private var scrollPos:Number = -1;
		
		private function tween(event:TimerEvent):void {
			var target:int = currentDot*105.5 - 1;
			if(scrollPos < 0)
				scrollPos = screenSelector.scroller.viewport.horizontalScrollPosition;
			scrollPos = 0.8*scrollPos + 0.2*target;
			if(Math.abs(target - scrollPos) < 2 ) {
				timer.stop();
				scrollPos = -1;
				screenSelector.scroller.viewport.horizontalScrollPosition = target;
				selectScreenByName(screenNames[currentDot+1]);
			}
			else {
				screenSelector.scroller.viewport.horizontalScrollPosition = Math.round(scrollPos);
			}
		}
			
		override public function onRegister() : void
		{
			profileValidSignal.add(enableCheck);

			timer = new Timer(5);
			timer.addEventListener(TimerEvent.TIMER, tween);
			
			screenSelector.dot0.addEventListener(MouseEvent.CLICK, dot0);
			screenSelector.dot1.addEventListener(MouseEvent.CLICK, dot1);
			screenSelector.dot2.addEventListener(MouseEvent.CLICK, dot2);
			screenSelector.dot3.addEventListener(MouseEvent.CLICK, dot3);
			screenSelector.dot4.addEventListener(MouseEvent.CLICK, dot4);
			screenSelector.dot5.addEventListener(MouseEvent.CLICK, dot5);
			screenSelector.dot6.addEventListener(MouseEvent.CLICK, dot6);
			
			screenSelector.futuresButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.heartAgeButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.deanfieldButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.outlookButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.outcomesButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.balanceButton.addEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.compareButton.addEventListener(MouseEvent.CLICK, selectScreen);
			
			dotAlpha(currentDot);

			screenSelector.profileButton.addEventListener(MouseEvent.CLICK, selectProfile);
			
			//trace("scroll at ", screenSelector.scroller.viewport.horizontalScrollPosition);
			//trace("dot = ", Math.round((screenSelector.scroller.viewport.horizontalScrollPosition + 1)/105.5));
			dot(Math.round((screenSelector.scroller.viewport.horizontalScrollPosition + 1)/105.5));
			
		}
		
		override public function onRemove() : void
		{
			profileValidSignal.remove(enableCheck);

			screenSelector.dot0.removeEventListener(MouseEvent.CLICK, dot0);
			screenSelector.dot1.removeEventListener(MouseEvent.CLICK, dot1);
			screenSelector.dot2.removeEventListener(MouseEvent.CLICK, dot2);
			screenSelector.dot3.removeEventListener(MouseEvent.CLICK, dot3);
			screenSelector.dot4.removeEventListener(MouseEvent.CLICK, dot4);
			screenSelector.dot5.removeEventListener(MouseEvent.CLICK, dot5);
			screenSelector.dot6.removeEventListener(MouseEvent.CLICK, dot6);

			screenSelector.futuresButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.heartAgeButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.deanfieldButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.outlookButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.outcomesButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.balanceButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			screenSelector.compareButton.removeEventListener(MouseEvent.CLICK, selectScreen);
			
			screenSelector.profileButton.removeEventListener(MouseEvent.CLICK, selectProfile);
			
			timer.removeEventListener(TimerEvent.TIMER, tween);

		}
		
		private var screenNames:Array = ['profile', 'futures', 'heartAge', 'deanfield', 'outlook', 'outcomes', 'balance', 'compare'];
		private var currentDot:int = 0;
		
		private function dotAlpha(target: int):void {
			for(var i:int = 0; i <= 6; i++) {
				screenSelector["dot" + i].alpha = i==target ? 1.0 : 0.3;
			}
			currentDot = target;
		}
		

		private function previousDot(e:MouseEvent):void {
			if(timer.running) return;
			if(currentDot > 0) {
				dot(--currentDot);
			}
		}
		
		private function nextDot(e:MouseEvent):void {
			if(timer.running) return;
			if(currentDot < 5) {
				dot(++currentDot);
			}
		}
		
		private function dot0(e:MouseEvent):void {
			dot(0);
		};
		private function dot1(e:MouseEvent):void {
			dot(1);
		};
		private function dot2(e:MouseEvent):void {
			dot(2);
		};
		private function dot3(e:MouseEvent):void {
			dot(3);
		};
		private function dot4(e:MouseEvent):void {
			dot(4);
		};
		private function dot5(e:MouseEvent):void {
			dot(5);
		};
		private function dot6(e:MouseEvent):void {
			dot(6);
		};
		
		
		
		private function dot(n:int):void {
			if(timer.running) return;
			
			dotAlpha(n);
			currentDot = n;
			timer.start();
		}
		
	
		private function enableCheck(enabled:Boolean):void {
			var alpha:Number = enabled ? 1 : 0.3;
			
			if(screenNames) {
			
				// skip profile
				for(var i:int = 1; i < screenNames.length; i++) {
					screenSelector[String(screenNames[i])+"Label"].alpha = alpha;
					screenSelector[String(screenNames[i])+"Button"].alpha = alpha;
					screenSelector[String(screenNames[i])+"Button"].enabled = enabled;
				}
			}
		}
				
		//
		// The screen selector buttons must be named mainPanel.state.name +'Button'
		//
		private function selectProfile(event:MouseEvent):void
		{
			
			selectScreenByName("profile");

		}
		
		
		//
		// The screen selector buttons must be named mainPanel.state.name +'Button'
		//
		private function selectScreen(event:MouseEvent):void
		{
			var targetButton:Button = event.target as Button;
			var id:String = targetButton.id;
			var bx:int = id.indexOf("Button");
			var screenName:String = id.substr(0, bx);
			if(bx < 1) throw new Error("Invalid button name: " + id);
			dot(screenNames.indexOf(screenName)-1);
		}
		
		
		private function selectScreenByName(name:String):void
		{
			if(name != appState.selectedScreenName) {
				
				appState.selectedScreenName = name;
				
				if(name != "profile") {
					profileCommitSignal.dispatch();
				}
				
				screenChangedSignal.dispatch(name);
			}
			
		}

	}
}