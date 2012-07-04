/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.model.vo
{
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;

	public class ShapeData
	{
		public var shape:String;
		public var fill:SolidColor;
		public var stroke:SolidColorStroke;
		public var tenths:int;
		public var dtenths:int;
		public var verticalCut:Boolean;
		
		public function ShapeData(shape:String="man", fill:SolidColor=null, stroke:SolidColorStroke=null, tenths:int = 10, dtenths:int = 10, verticalCut:Boolean = true)
		{
			this.shape = shape;
			this.fill = fill;
			this.stroke = stroke;
			this.tenths = tenths;
			this.dtenths = dtenths;
			this.verticalCut = verticalCut;
		}
	}
}