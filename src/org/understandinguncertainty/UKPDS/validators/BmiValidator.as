/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class BmiValidator extends Validator
	{
		public function BmiValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);
			
			if (results.length > 0)
				return results;
			
			var ratio:Number = Number(value);
			if(ratio < 15) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"BMI too small")
					);
			}
			else if(ratio > 45) {
				results.push(new ValidationResult(
					true, "", "OutOfRange", 
					"BMI too big")
					);
			}

			return results;
		}
	}
}