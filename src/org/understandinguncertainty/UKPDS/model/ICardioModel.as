/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model
{
	import mx.collections.ArrayCollection;
	
	import org.understandinguncertainty.UKPDS.model.vo.ColourNumbersVO;

	public interface ICardioModel
	{
		
		function getResultSet():ArrayCollection;
		function get yearGain():Number;
		function get meanAge():Number;
		
		function set heartAge(i:Number):void
		function get heartAge():Number;
		
		function get heartAgeText():String;
		function set heartAgeText(value:String):void;
		
		
		/**
		 * returns the minimum acceptable value of the outlook (-ve) vertical axis slider
		 */
		function get peakYellowPadded():Number;
		
		/**
		 * @return counts of each colour in balance views
		 */
		function get colourNumbers():ColourNumbersVO
			
		/** 
		 * Recalculates the model based on current properties
		 */
		function commitProperties():void

		/**
		 * @param b sets whether to show differences in the UI
		 */
		function set showDifferences(b:Boolean):void
		
		/**
		 * @return whether to show differences in the UI
		 */
		function get showDifferences():Boolean
		
		/**
		 * @return peak cardiovascular risk
		 */   
		function get peakf():Number;
	}
}