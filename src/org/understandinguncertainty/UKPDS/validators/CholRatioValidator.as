/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class CholRatioValidator extends Validator
	{
		public function CholRatioValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);
			
			if (results.length > 0)
				return results;
			
			var ratio:Number = Number(value);
			if(ratio < 1) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"Cholesterol ratio too small")
					);
			}
			else if(ratio > 12) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"Cholesterol ratio too big")
					);
			}

			return results;
		}
	}
}