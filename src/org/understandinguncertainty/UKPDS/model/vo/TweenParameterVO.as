/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	public class TweenParameterVO
	{
		public var bmi:TweenConfig = new TweenConfig(0,1,1);
		public var bmi:TweenConfig = new TweenConfig(0,1,1);
		
		tweenConfig:XML = <interventionTweens>
				<tweenConfig name="bmi" delay="0" duration="0" proportion="1"/>
				<tweenConfig name="smoking" delay="0" duration="0" proportion="1"/>
			</interventionTweens>;
		
		function tween(parameter:String, t:int, from:Number, to:Number):Number
		{
						
		}
		
		
	}
}