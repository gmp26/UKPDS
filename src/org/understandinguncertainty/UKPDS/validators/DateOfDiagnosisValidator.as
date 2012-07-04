/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.validators
{
	import mx.validators.DateValidator;
	import mx.validators.ValidationResult;
	
	public class DateOfDiagnosisValidator extends DateValidator
	{
		
		public function DateOfDiagnosisValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);

			if (results.length > 0)
				return results;
			
			var yyyy:int = parseInt(value.year);
			var mm:int = parseInt(value.month) - 1;
			var dd:int = parseInt(value.day);
			
			var now:Date = new Date();
			if((yyyy > now.fullYear)
				|| (yyyy == now.fullYear && ( mm > now.month
					|| mm == now.month && dd > now.date))) {
				
				results.push(new ValidationResult(
					true, "year", "futureDate",
					"Diagnosis in the future!"));
				return results;
			}
			
			if( yyyy + 84 < now.fullYear)  {
				
				// Diagnosis improbably far in the past
				results.push(new ValidationResult(
					true, "year", "tooOld",
					"Diagnosis over 84 years ago"));
				return results;
			}
			return results;
		}
	}
}