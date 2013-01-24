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
	import org.understandinguncertainty.personal.signals.NextScreenSignal;
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
		public var nextScreenSignal:NextScreenSignal;
		
		[Inject]
		public var appState:AppState;
		
		// If basic is true we only show the basic screen selection buttons
		private function get basic():Boolean {
			return screenSelector.currentState == 'basic';
		};
		
		override public function onRegister() : void
		{
			profileValidSignal.add(enableCheck);
			screensNamedSignal.add(addThumbnails);
			nextScreenSignal.add(nextScreen);

			screenSelector.less.addEventListener(MouseEvent.CLICK, dot1);
			screenSelector.more.addEventListener(MouseEvent.CLICK, dot6);
			screenSelector.dot1.addEventListener(MouseEvent.CLICK, dot1);
			screenSelector.dot2.addEventListener(MouseEvent.CLICK, dot2);
			screenSelector.dot3.addEventListener(MouseEvent.CLICK, dot3);
			screenSelector.dot4.addEventListener(MouseEvent.CLICK, dot4);
			screenSelector.dot5.addEventListener(MouseEvent.CLICK, dot5);
			screenSelector.dot6.addEventListener(MouseEvent.CLICK, dot6);
			
			dotAlpha(1, false);

			screenSelector.profileButton.addEventListener(MouseEvent.CLICK, selectProfile);
		}
		
		override public function onRemove() : void
		{
			profileValidSignal.remove(enableCheck);
			screensNamedSignal.remove(addThumbnails);
			nextScreenSignal.remove(nextScreen);
			removeThumbnails();
			screenSelector.less.removeEventListener(MouseEvent.CLICK, dot1);
			screenSelector.more.removeEventListener(MouseEvent.CLICK, dot6);
			screenSelector.dot1.removeEventListener(MouseEvent.CLICK, dot1);
			screenSelector.dot2.removeEventListener(MouseEvent.CLICK, dot2);
			screenSelector.dot3.removeEventListener(MouseEvent.CLICK, dot3);
			screenSelector.dot4.removeEventListener(MouseEvent.CLICK, dot4);
			screenSelector.dot5.removeEventListener(MouseEvent.CLICK, dot5);
			screenSelector.dot6.removeEventListener(MouseEvent.CLICK, dot6);

			screenSelector.profileButton.removeEventListener(MouseEvent.CLICK, selectProfile);
		}
		
		private var screenNames:Array;
		private var buttons:Vector.<Button>;
		
		private function dotAlpha(target: int, andGo:Boolean=true):void {
			for(var i:int = 1; i <= 6; i++) {
				screenSelector["dot" + i].alpha = i==target ? 1.0 : 0.3;
			}
			if(andGo)
				buttons[target-1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function dot1(e:MouseEvent):void {
			dot(0);
			dotAlpha(1);
		};
		private function dot2(e:MouseEvent):void {
			dot(1);
			dotAlpha(2);
		};
		private function dot3(e:MouseEvent):void {
			dot(2);
			dotAlpha(3);
		};
		private function dot4(e:MouseEvent):void {
			dot(3);
			dotAlpha(4);
		};
		private function dot5(e:MouseEvent):void {
			dot(4);
			dotAlpha(5);
		};
		private function dot6(e:MouseEvent):void {
			dot(5);
			dotAlpha(6);
		};
		
		private function dot(target:int):void {
			var target = target*110;
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				var n:int = Math.round(0.8*screenSelector.scroller.viewport.horizontalScrollPosition + 0.2*target);
				if(Math.abs(target - n) <= 5 ) {
					n = target;
					timer.stop();
				}
				screenSelector.scroller.viewport.horizontalScrollPosition = n;
			});
			timer.start();
		}
		
		private function scrollBack(event:MouseEvent):void {
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				var n:int = Math.round(0.8*screenSelector.scroller.viewport.horizontalScrollPosition);
				if(n < 5) {
					n = 0;
					timer.stop();
				}
				screenSelector.scroller.viewport.horizontalScrollPosition = n;
			});
			timer.start();
		}
		
		private function scrollOn(event:MouseEvent):void {
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				var n:int = Math.round(0.8*screenSelector.scroller.viewport.horizontalScrollPosition + 325*0.2);
				if(n > 320) {
					n = 325;
					timer.stop();
				}
				screenSelector.scroller.viewport.horizontalScrollPosition = n;
			});
			timer.start();
		}
		
		
		private function addThumbnails(screenNames:Array):void
		{
			this.screenNames = screenNames.concat();
			
			// populate basic thumbnails. We assume basics come before advanced ones
			var basicLength:int = screenSelector.basicThumbnails.numElements;
			populateThumbnailContainer("basicContainer", 0, basicLength);
 
			// populate advanced thumbnails
			// populateThumbnailContainer("advancedContainer", basicLength, this.screenNames.length);

		}
		
		private function populateThumbnailContainer(containerId:String, minIndex:int, len:int):void
		{
			if(buttons == null)
				buttons = new Vector.<Button>();
			
			for(var i:int = minIndex; i < len-1; i++) {
				var screenName:String = this.screenNames[i+1] as String;
				var thumbnail:GroupBase = screenSelector[screenName] as GroupBase;
				screenSelector[containerId].addElement(thumbnail);
				buttons[i] = screenSelector[screenName+"Button"] as Button;
				buttons[i].addEventListener(MouseEvent.CLICK, selectScreen);
			}			
		}
		
		private function removeThumbnails():void
		{
			for(var i:int = 0; i < buttons.length; i++) {
				buttons[i].removeEventListener(MouseEvent.CLICK, selectScreen);
			}
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
				
		private function nextScreen(currentScreen:String):void
		{
			var index:int = screenNames.indexOf(appState.selectedScreenName);
			index = (index + 1) % screenNames.length;
			selectScreenByName(screenNames[index]);
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

			if(bx < 1) throw new Error("Invalid button name: " + id);

			trace(id.substr(0, bx));
			selectScreenByName(id.substr(0, bx));

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
		
		private function changeMode(event:MouseEvent):void
		{
			if(basic)
				screenSelector.currentState = "advanced";
			else
				screenSelector.currentState = "basic";
		}

	}
}