/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	import mx.core.UIComponent;

	public class WidthHeightMeasurement
	{
		public var component:UIComponent;
		public var width:Number;
		public var height:Number;
		
		public function WidthHeightMeasurement(c:UIComponent, w:Number, h:Number)
		{
			component = c;
			width = w;
			height = h;
		}
	}
}